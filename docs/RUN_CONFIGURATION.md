# Execução do serviço

## Execução local

1. Certifique-se de ter cumprido com os pré-requisitos;

2. Acesse os diretórios environments >> dev;

3. Remova o nome `-example` do arquivo tfvars. Preencha as variáveis presentes no arquivo terraform-tfvars;

4. No mesmo diretório execute o comando no terminal da sua maquina ou IDE:

```sh
./terraform_init.sh init
```

5. Execute agora o comando abaixo, fazendo as devidas confirmações também

```sh
terraform plan
```

6. Execute o comando para aplicar e provisionar a infraestrutura

```sh
terraform apply
```

7. Para prosseguir com a configuração dos serviços. Acesse o repositório `hackaton-api`.

8. altere as variáveis de ambiente e rode npx prisma migrate deploy para criar as tabelas do banco de dados. 

9. Entre na AWS e cadastre seu telefone no recurso Simple Notification Service -> Mobile/Text messaging (SMS)


## Execução Git Actions

1. Certifique-se de ter configurado as váriaveis respectivas ao repositório e a organização corretamente;

2. Acesse o menu `Actions` do repositório no GitHub, clique no botão New workflow e execute manualmente a ação de deploy. Essa fará a criação e provisionamento dos recursos na cloud AWS;

3. Para prosseguir com a configuração dos serviços. Acesse o repositório `hackaton-api`.

4. altere as variáveis de ambiente e rode npx prisma migrate deploy para criar as tabelas do banco de dados. 

5. Entre na AWS e cadastre seu telefone no recurso Simple Notification Service -> Mobile/Text messaging (SMS)