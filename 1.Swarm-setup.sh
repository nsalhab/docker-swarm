#!/usr/bin/env bash
date
if [[ "$(uname -s )" == "Linux" ]]; then
  export VIRTUALBOX_SHARE_FOLDER="$PWD:$PWD"
fi

for i in {1..6}; do
docker-machine create --driver "virtualbox" --virtualbox-cpu-count "1" --virtualbox-memory "1024" --virtualbox-disk-size "20000" --virtualbox-boot2docker-url "https://github.com/boot2docker/boot2docker/releases/download/v18.09.1-rc1/boot2docker.iso" swarm-$i
done

eval $(docker-machine env swarm-1)
docker swarm init  --advertise-addr $(docker-machine ip swarm-1)

TOKEN=$(docker swarm join-token -q manager)
for i in {2..6}; do 
eval $(docker-machine env swarm-$i)
docker swarm join --token $TOKEN $(docker-machine ip swarm-1):2377
docker node demote swarm-$i
done


echo ">> The swarm cluster is up and running"
date
virtualbox &

# 10 nodes, if need other number, please change in both for-loops

