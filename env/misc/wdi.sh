#!/usr/bin/env bash

if [ -z "$1" ]
then
      read -p 'Enter folder name (empty for using current folder): ' PROJECT_NAME
else
  PROJECT_NAME=$1

  echo "Folder name is: ${PROJECT_NAME}"
fi

if [ -z "$2" ]
then
      read -p 'Enter cloud project ID (empty to skip downloading dumps): ' CLOUD_PROJECT_ID
else
  CLOUD_PROJECT_ID=$2

  echo "Cloud project ID is: ${CLOUD_PROJECT_ID}"
fi

if [ -z "$3" ] && [ -n "$CLOUD_PROJECT_ID" ]
then
      magento-cloud env:list -p ${CLOUD_PROJECT_ID} -I --format plain --pipe
      read -p 'Enter environment ID: ' CLOUD_ENV_ID
else
  CLOUD_ENV_ID=$3

  echo "Cloud environment ID is: ${CLOUD_ENV_ID}"
fi

PROJECT_NAME="${PROJECT_NAME//-/}"
PROJECT_NAME=$(echo "$PROJECT_NAME" |  tr '[:upper:]' '[:lower:]' )

if [ -z "${PROJECT_NAME}" ]
then
  PROJECT_NAME=$(basename "$(pwd)")
else
  mkdir ${PROJECT_NAME}
  cd $_
fi

echo "Project folder is ${PROJECT_NAME}"

if [ -z "$CLOUD_PROJECT_ID" ]
then
      echo "project id not specified"
else
      SSH_HOST=`eval magento-cloud environment:ssh --all --project $CLOUD_PROJECT_ID -e $CLOUD_ENV_ID --pipe`
      SSH_HOST=$(echo "$SSH_HOST" | head -1)
      echo "SSH Host is: ${SSH_HOST}"
fi

if [ -n "$CLOUD_PROJECT_ID" ]
then
      cloud-teleport ${SSH_HOST} dump
fi

m2install.sh