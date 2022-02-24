#!/bin/sh
docker-compose -f ./redis-server.yml down 
docker-compose -f ./redis-server.yml up -d
docker ps

# docker exec -it redis_boot redis-cli