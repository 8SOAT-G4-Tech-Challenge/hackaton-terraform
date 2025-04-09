1- Preencha as variáveis de ambiente
2- Acesse a pasta environments/dev e rode o comando `./terraform-init.sh init`
3- Rode os comandos: `terraform apply -target=module.vpc -target=module.security -target=module.eks.aws_eks_cluster.eks_cluster -auto-approve`
3.1- Rode os comandos `terraform apply -target=module.eks.aws_eks_access_entry.eks_access_entry -target=module.eks.aws_eks_access_policy_association.policy_association`
4- Rode os comandos: `terraform apply -target=module.eks.aws_eks_node_group.eks_node_group -auto-approve`
5- Rode os comandos: `terraform apply -auto-approve`
