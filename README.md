# Teste Zedelivery

1 - Utilizando Terraform, crie um ambiente na AWS utilizando o serviço Bucket S3 para hospedar o site estático com base nas melhores práticas de segurança.

R - > Fiz uso de um terraform modular, para essa questao usei s3 e cloudfront, s3 sendo privado e possivel seu acesso por meio do cloudfront. 

Para provisionamento do terraform, antes crie o bucket do state do terraform na sua conta aws. com nome de **ze-terraform-state** como esta especificado no arquivo providers.tf

terraform init
terraform plan -target=module.s3-site -lock=false
terraform apply -target=module.s3-site -lock=false

2 - Utilizando Terraform, crie uma instância EC2 contendo uma role policy contendo permissão apenas para acessar o serviço do Bucket S3 apenas para leitura, criando também um grupo de segurança permitindo apenas o serviço SSH para uma rede privada.

R -> Da mesma forma que foi usado na questao anterior, um terraform modular, para essa questao foi necessario o modulo de networking, pois a ec2 precisava esta em uma rede privada com acesso ssh a porta 22 liberada para rede. 

## Provisionando Rede
terraform init
terraform plan -target=module.networking -lock=false
terraform apply -target=module.networking -lock=false

## Provisionando Ec2
terraform init
terraform plan -target=module.ec2 -lock=false
terraform apply -target=module.ec2 -lock=false

