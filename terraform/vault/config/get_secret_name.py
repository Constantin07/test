"""
Gets the secret token name for a service account
"""

import sys
from terraform_external_data import terraform_external_data
from kubernetes import client, config

# pylint: disable=no-value-for-parameter,invalid-name

@terraform_external_data
def get_secret_name(query):
    """ Returns a secret token name associated with service account """
    namespace = query['namespace']
    name = query['service_account_name']

    config.load_kube_config()
    v1 = client.CoreV1Api()

    sa = v1.read_namespaced_service_account(name, namespace)
    if not sa:
        print("Service account %s does not exist. Exiting ..." % name)
        sys.exit(1)

    return {'token_name': sa.secrets[0].name}


if __name__ == '__main__':
    get_secret_name()
