#!/bin/sh -eu

function generateSshKeys {
    echo "Generating SSH keys."
    ssh-keygen -N "" -f .ssh/id_rsa
    echo "SSH keys generated. This is the public key: "
    cat .ssh/id_rsa.pub
}

if [ -d .ssh ]; then
  echo ".ssh directory already exists (passed from host). Checking if keys are present."
  if [ -z "$(ls -A .ssh)" ]; then
    echo "No keys found in folder. Generating new keys"
    generateSshKeys
  else
    echo "Keys found in folder. Skipping key generation"
  fi
else
    echo ".ssh directory not found. Creating folder and generating keys."
    mkdir .ssh
    generateSshKeys
fi

echo "Started deployer container. Please exec into this conteinr and run cap command"
sleep infinity