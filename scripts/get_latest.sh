#!/usr/bin/env bash

# Get the latest tag from GitHub repository

if [ $# -ne 3 ]; then
    echo "Usage: $0 <user> <repository_name>"
    echo "Where:"
    echo -e "\t <user> - GitHub user (required)"
    echo -e "\t <repository_name> - GitHub repository name (required)"
    echo -e "\t <type> - can be 'tag' or 'release' (required)"
    echo "Example: $0 terraform-providers terraform-provider-aws tag"
    exit 1
fi

github='https://api.github.com/repos'
user=$1
repository=$2
type=$3

case $type in
    'tag')
	latest="$(curl -sSL "${github}/${user}/${repository}/tags" | jq -r '.|sort_by(.name)[-1]|.name|ltrimstr("v")')"
	;;
    'release')
	latest="$(curl -sSL "${github}/${user}/${repository}/releases/latest" | jq -r '.tag_name|ltrimstr("v")')"
	;;
esac

echo "${latest}"
