#!/usr/bin/env bash


eval $(docker-machine env swarm-1)
echo ">> Deploying the Visualizer"

docker stack deploy --compose-file stacks/oss.yml oss

echo ">> Deploying the App Stack"



docker service create --name oai-cn -d alpine ping docker.com
docker service create --name nginx -d -p 81:80 nginx
#docker service create --name oai-cn-web -d -p 8079:80 kitematic/hello-world-nginx


#docker stack deploy --compose-file stacks/oai.yml oai

echo ">> Both Stacks are deployed, Please wait their readiness by checking the REPLICAS is 1/1 in 'watch docker service ls'"
echo ">> Activate the docker-machine member of swarm before issuing a/m command by: eval"



# docker service create --name oai-cn alpine ping docker.com
# docker node update --label-add embb=yes --label-add mmtc=no  --label-add urllc=no  swarm-1
# docker node update --label-add embb=no  --label-add mmtc=yes --label-add urllc=no  swarm-2
# docker node update --label-add embb=no  --label-add mmtc=no  --label-add urllc=yes swarm-3

# docker service create --name nginx -p 80:80 nginx




#eval $(docker-machine env swarm-1)
#docker service ls
#docker service ps oss_visualizer


# add option --follow to keep logs flowing permanently

#docker service inspect oss_visualizer --pretty | grep -i constraint

# Take the list of constraints as-is from within the bracket of previous command

# docker service update --constraint-rm 'node.role == manager' oss_visualizer

# docker service scale oss_visualizer=3


#docker service logs oss_visualizer

# Install Grafana
#docker run -d --name=grafana -p 3000:3000 grafana/grafana

# Install Influxdb, at first before telegraf
#docker run -d --name influxdb -p 8083:8083 -p 8086:8086 -e INFLUXDB_DB=db0 -e INFLUXDB_ADMIN_ENABLED=true -e INFLUXDB_ADMIN_USER=admin -e INFLUXDB_ADMIN_PASSWORD=supersecretpassword -e INFLUXDB_USER=telegraf -e INFLUXDB_USER_PASSWORD=secretpassword -v $PWD/influxdb:/var/lib/influxdb   influxdb

# Once finished with influxdB, Install Telegraf, ATTENTION THE SECRET is in the --net=container:influxdb to expose the port to influxdb
#docker run -d --name telegraf --net=container:influxdb telegraf 


