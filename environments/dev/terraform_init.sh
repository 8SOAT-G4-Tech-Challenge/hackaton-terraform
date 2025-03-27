#!/bin/bash

# Verifica se o comando é 'terraform init'
if [ "$1" == "init" ]; then
  # Chama o script para verificar/criar o bucket e inicializar o Terraform
  ../../scripts/create_bucket_and_init.sh
else
  # Se não for 'init', passa o comando para o terraform normalmente
  terraform "$@"
fi
