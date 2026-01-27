# KTS infra

## KTS architecture

<img src="./assets/KTS-architecture.png" width="700">

## Create infrastructure using terraform

- jenkins
- sonarqube
- deployment server

## sonaqube is in private subnet, but from our computers we want to connect to sonarqube

- we will use ssh port forwarding

```bash
ssh -i ~/.ssh/<jumphost key> -L 9000:<sonar server private key>:9000 <user>@<jump host public key>
```
