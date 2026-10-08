# 3-tier web app en AWS con Terraform

Una línea: qué es y qué demuestra.

## Arquitectura
Diagrama + 3-4 líneas: ALB público → EC2 en Auto Scaling (subnets privadas, salida por NAT) → RDS MySQL.

## Qué despliega
VPC con 6 subnets en 2 AZ, IGW y NAT, ALB, ASG con launch template, RDS, security groups encadenados (ALB → EC2 → RDS) e IAM.

## Estructura
modules/webapp/      módulo reutilizable
stage/ y prod/       un directorio raíz por entorno, cada uno con su state y su región
s3_backend_origin/   crea el bucket de state (state local, es el bootstrap)

## Cómo desplegar
Requisitos: Terraform >= X, credenciales de AWS, TF_VAR_db_password.
1. s3_backend_origin → terraform apply
2. stage → terraform init / plan / apply
3. Abrir el output alb_dns en el navegador (http, no https)

## Coste
NAT, ALB y RDS cobran por hora. terraform destroy al terminar.

## Decisiones y limitaciones conocidas
- Contraseña de RDS pasada por variable sensible, y llega al user_data. Pendiente: Secrets Manager + IAM auth.
- Un solo NAT gateway (no es alta disponibilidad).
- Sin HTTPS.