#!/bin/bash
if [ ! -d backups ]; then
	mkdir backups
fi

docker cp image/«your image name»-backup.sh tsb-ft-jenkins:~/«your image name»-backup.sh
docker exec «your container name» ~//«your image name»-backup.sh
timestamp=$(date +%Y-%m-%dT%H.%M.%S)
echo $timestamp
docker cp «your container name»:/«whatever».zip backups/$timestamp.zip
