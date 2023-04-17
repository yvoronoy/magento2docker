#!/usr/bin/env bash
# shellcheck shell=bash

function _m2d_install_apache_init_ahut_json ()
{
    local confirm target_file

    target_file="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)/../etc/composer/auth.json"

    if [[ -f "$target_file"  ]]; then
        read -p 'You already have auth.json file generated for Magento2Docker. Do you want to keep it (y) or recreate it (n)? [y/n]: ' confirm

        if [[ $confirm == 'y' ]]; then
            return 0
        fi

        mv "$target_file" "$target_file.backup"
        echo "The current auth.json file has been archived to: $target_file.backup"
    fi

    if [[ -f ~/.composer/auth.json ]]; then
        read -p 'Do you want to use your auth.json file from the host (~/.composer/auth.json)? [y/n]: ' confirm

        if [[ $confirm == 'y' ]]; then
            cp ~/.composer/auth.json "$target_file"
            return 0
        fi
    fi

    echo 'You can use any existing auth.json file or you will be asked to provide public and private composer keys.'
    read -p 'Do you want to use any existing auth.json file? [y/n]: ' confirm
    if [[ $confirm == 'y' ]]; then
        local auth_json_path
        while [[ ! -f "$target_file" ]]
        do
            read -p 'Provide a path to auth.json file you want to use: ' auth_json_path
            auth_json_path=$(realpath "${auth_json_path/#\~/$HOME}" 2> /dev/null)

            echo "$auth_json_path"

            if [[ -f "$auth_json_path" ]]; then
                cp "$auth_json_path" "$target_file"
                return 0
            fi

            read -p "'$auth_json_path' doesn't exist! Do you want to try again? [y/n]: " confirm

            if [[ $confirm == 'n' ]]; then
                break
            fi
        done
    fi

    local username password file_content
    echo 'The auth.json file will be generated based on your public and private keys.'
    read -p 'Provide a public key to repo.magento.com: ' username
    read -p 'Provide a private key to repo.magento.com: ' password

    file_content=$(cat <<AUTH_JSON
{
    "http-basic": {
        "repo.magento.com": {
            "username": "$username",
            "password": "$password"
        }
    }
}
AUTH_JSON
    )

    echo "$file_content" >> "$target_file"
}

function _m2d_install_apache_init_git_config ()
{
    local confirm target_file

    target_file="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)/../etc/git/gitconfig"

    if [[ -f "$target_file"  ]]; then
        read -p 'You already have a git config file created for Magento2Docker. Do you want to keep it? [y/n]: ' confirm

        if [[ $confirm == 'y' ]]; then
            return 0
        fi

        mv "$target_file" "$target_file.backup"
        echo "The current git config file has been archived to: $target_file.backup"
    fi

    if [[ -f ~/.gitconfig ]]; then
        read -p 'Do you want to use your current gitconfig file from the host (from ~/.gitconfig)? [y/n]: ' confirm

        if [[ $confirm == 'y' ]]; then
            cp ~/.gitconfig "$target_file"
            return 0
        fi
    fi

    local email name file_content
    echo 'Generating minimal git configuration:'
    read -p 'Provide your email address: ' email
    read -p 'Provide your full name (name and surname): ' name

    file_content=$(cat <<GITCONFIG
[user]
	email = $email
	name = $name

GITCONFIG
    )

    echo "$file_content" >> "$target_file"
}

function _m2d_install_apache_init_certs ()
{
    local confirm
    local target_path="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)/../etc/ssh"

    echo 'You may want to add your ssh configuration and keys to the web container, so you will be able to connect to external services like e.g. GithHub'

    if [[ -f ~/.ssh/config ]]; then
        read -p 'Do you want to add SSH config file(s) from the host to the web container? [y/n]: ' confirm

        if [[ $confirm == 'y' ]]; then
            cp ~/.ssh/config* "$target_path/"
        fi
    fi

    if [[ -f ~/.ssh/known_hosts ]]; then
        read -p 'Do you want to add known_hosts file from the host to the web container? [y/n]: ' confirm

        if [[ $confirm == 'y' ]]; then
            cp ~/.ssh/known_hosts "$target_path/"
        fi
    fi

    read -p 'Do you want to add any of your SSH keys to the web container (you will be able to select which keys to add)? [y/n]: ' confirm

    if [[ $confirm == 'n' ]]; then
        return 0
    fi

    for ssh_pub_key in ~/.ssh/*.pub; do
        if [[ "$(basename $ssh_pub_key)" == 'magento2docker.pub' ]]; then
            continue
        fi

        read -p "Add '$ssh_pub_key'? [y/n]: " confirm

        if [[ $confirm != 'y' ]]; then
            continue
        fi

        cp "$ssh_pub_key" "$target_path/$(basename $ssh_pub_key)"
        cp "${ssh_pub_key%.pub}" "$target_path/$(basename ${ssh_pub_key%.pub})"
    done
}

_m2d_install_apache_init_ahut_json
_m2d_install_apache_init_git_config
_m2d_install_apache_init_certs
