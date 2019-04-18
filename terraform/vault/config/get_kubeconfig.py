from terraform_external_data import terraform_external_data

import os, json, yaml

# Returns a map of:
# 1. cluster endpoint <server>
# 2. CA cert <certificate-authority-data>
# Limitations: One cluster expected in kube config file.

@terraform_external_data
def get_kubeconfig(query):
    with open(os.path.expanduser(query['config_file']), 'r') as infile:
        return yaml.load(infile.read())['clusters'][0]['cluster']

if __name__ == '__main__':
    get_kubeconfig()
