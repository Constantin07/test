from terraform_external_data import terraform_external_data

import os, json, yaml
from kubernetes import client, config

# Returns a map of:

@terraform_external_data
def get_secret_name(query):
    namespace = query['namespace']
    name = query['service_account_name']

    config.load_kube_config()
    v1 = client.CoreV1Api()

    sa = v1.read_namespaced_service_account(name, namespace)
    if not sa:
        print("Service account %s does not exist. Exiting ..." % name)
        exit(1)

    token_name = sa.secrets[0].name

    return { 'token_name': token_name }

if __name__ == '__main__':
     get_secret_name()
