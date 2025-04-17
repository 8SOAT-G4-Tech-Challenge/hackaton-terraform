# Execução do serviço

## Execução local

1 - Certifique-se de ter cumprido com os pré-requisitos;

2 - Acesse o diretório environments >> dev;

3 - Remova o nome `-example` do arquivo tfvars. Preencha as variáveis presentes no arquivo terraform-tfvars;

4 - Na mesmo diretório execute o comando no terminal da sua maquina ou IDE:

```sh
./terraform_init.sh init
```

5 - Execute agora o comando abaixo, fazendo as devidas confirmações também

```sh
terraform plan
```

6 - Execute o comando para aplicar e provisionar a infraestrutura

```sh
terraform apply
```


## Execução Git Actions

1 - Certifique-se de ter configurado as váriaveis respectivas ao repositório e a organização corretamente;

2 - Acesse o menu `Actions` do repositório no GitHub, clique no botão New workflow e execute manualmente a ação de deploy. Essa fará a criação e provisionamento dos recursos na cloud AWS.