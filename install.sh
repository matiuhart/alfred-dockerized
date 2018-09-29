#!/bin/bash

curl -sSL https://get.docker.com/ | sh

usermod -aG docker pi

pip install docker-compose

echo -e "\e[31mATENCION\e[0m"
echo -e "\e[32mEs necesario reiniciar el sistema, luego posicionarse sobre el directorio de alfred y ejecutar docker-compose up -d\e[0m"