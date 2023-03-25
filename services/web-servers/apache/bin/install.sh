#!/usr/bin/env bash
# shellcheck shell=bash

function _m2d_install_apache_init_ahut_json ()
{
    local confirm target_file

    target_file="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)/../etc/composer/auth.json"

    if [[ -f "$target_file"  ]]; then
        read -p 'You already have auth.json file. Do you want to keep it? [y/n]: ' confirm

        if [[ $confirm == 'y' ]]; then
            return 0
        fi

        mv "$target_file" "$target_file.backup"
    fi

    if [[ -f ~/.composer/auth.json ]]; then
        read -p 'Do you want to use your current auth.json file (from ~/.composer/auth.json)? [y/n]: ' confirm

        if [[ $confirm == 'y' ]]; then
            cp ~/.composer/auth.json "$target_file"
            return 0
        fi
    fi

    read -p 'Do you want to use existing auth.json file? [y/n]: ' confirm
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

            read -p "'$auth_json_path' doesn't exists! Do you want to try again? [y/n]: " confirm

            if [[ $confirm == 'n' ]]; then
                break
            fi
        done
    fi

    local username password file_content
    read -p 'Provide public key to repo.magento.com: ' username
    read -p 'Provide private key to repo.magento.com: ' password

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
        read -p 'You already have gitconfig file. Do you want to keep it? [y/n]: ' confirm

        if [[ $confirm == 'y' ]]; then
            return 0
        fi

        mv "$target_file" "$target_file.backup"
    fi

    if [[ -f ~/.gitconfig ]]; then
        read -p 'Do you want to use your current gitconfig file (from ~/.gitconfig)? [y/n]: ' confirm

        if [[ $confirm == 'y' ]]; then
            cp ~/.gitconfig "$target_file"
            return 0
        fi
    fi

    local email name file_content
    read -p 'Provide your email addres: ' email
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

    if [[ -f ~/.ssh/config ]]; then
        read -p 'Do you want to add SSH config file(s) to the web container? [y/n]: ' confirm

        if [[ $confirm == 'y' ]]; then
            cp ~/.ssh/config* "$target_path/"
        fi
    fi

    if [[ -f ~/.ssh/known_hosts ]]; then
        read -p 'Do you want to add known_hosts file to the web container? [y/n]: ' confirm

        if [[ $confirm == 'y' ]]; then
            cp ~/.ssh/known_hosts "$target_path/"
        fi
    fi

    read -p 'Do you want to select the SSH keys to be added to the web container? [y/n]: ' confirm

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
