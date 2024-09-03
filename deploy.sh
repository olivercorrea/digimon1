#!/bin/bash

# Crear una red Docker personalizada si no existe
docker network create --driver bridge my-network 2>/dev/null || true

# Detener y eliminar los contenedores existentes si existen
docker stop digimon-microservice-container digimon-frontend-container my-flask-container 2>/dev/null
docker rm digimon-microservice-container digimon-frontend-container my-flask-container 2>/dev/null

# Construir la imagen Docker para el microservicio
docker build -t my-digimonapi -f ./DigimonApi/Dockerfile ./DigimonApi

# Ejecutar el contenedor del microservicio
docker run -d --network my-network --restart=always -p 8080:80 --name digimon-microservice-container my-digimonapi

# Esperar a que el microservicio se inicie
sleep 5

# Construir la imagen Docker para Flask
docker build -t my-flask-app -f ./digimon-flask/Dockerfile ./digimon-flask

# Ejecutar el contenedor de Flask
docker run -d --network my-network --restart=always -p 5000:5000 --name my-flask-container my-flask-app

# Esperar a que Flask se inicie
sleep 5

# Construir la imagen Docker para el frontend
docker build -t digimon-frontend -f ./digimon-frontend/Dockerfile ./digimon-frontend

# Ejecutar el contenedor del frontend
docker run -d --network my-network --restart=always -p 8081:80 --name digimon-frontend-container digimon-frontend

# Esperar a que el frontend se inicie
sleep 5

echo "Aplicación en ejecución:"

echo "Microservicio: http://localhost:8080/recommendations?digimonName=<digimon_name>"
echo "Flask API: http://localhost:5000/recommend?digimon_name=<digimon_name>"
echo "Frontend: http://localhost:8081"

# Esperar un momento para que las aplicaciones se inicien
sleep 10

# Verificar si el microservicio está respondiendo
if curl -sSf http://localhost:8080/recommendations?digimonName=Gatomon >/dev/null 2>&1; then
    echo "El microservicio está respondiendo correctamente."
else
    echo "Error: El microservicio no está respondiendo. Revisa los logs del contenedor."
    docker logs digimon-microservice-container
fi

# Verificar si el backend Flask está respondiendo
if curl -sSf http://localhost:5000/recommend?digimon_name=Agumon >/dev/null 2>&1; then
    echo "El backend Flask está respondiendo correctamente."
else
    echo "Error: El backend Flask no está respondiendo. Revisa los logs del contenedor."
    docker logs my-flask-container
fi

# Verificar si el frontend está respondiendo
if curl -sSf http://localhost:8081 >/dev/null 2>&1; then
    echo "El frontend está respondiendo correctamente."
else
    echo "Error: El frontend no está respondiendo. Revisa los logs del contenedor."
    docker logs digimon-frontend-container
fi
