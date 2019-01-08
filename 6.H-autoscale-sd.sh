#!/bin/bash
 
maxthr=90
minthr=10
 
docker service update --constraint-rm 'node.role==manager' oai-cn
while :;
do
 
 
 
names=$(docker stats --format "{{.Name}}" --no-stream)
# Get the names of the containers
 
for name in $names; do
# Loop thru the names, one name by name
  percentage=$(docker stats $name --format "{{.CPUPerc}}" --no-stream)
#  percentage=$(docker stats $name --format "{{.MemPerc}}" --no-stream)
# get their Percentage
  pf="${percentage//%}"
# remove the percentage sign
 
  p=${pf%.*}
# convert the float number to integer
 
 if [ "$p" -gt $maxthr ]
 then
    echo "Microservice" $name " is overloaded"
    echo "Load is " $p "%"
    service=`echo $name | cut -d '.' -f1`
    echo "Parent Service is: " $service
    creplicas=$(docker service ps $service | grep Running | wc -l)
    echo "Current number of Replicas is: " $creplicas
    replicas=$((creplicas+1))
 
    echo "New Number of Replicas after scale out is: " $replicas
    (docker service scale -d $service=$replicas)    
 fi
 
 if [ "$p" -lt $minthr ]
 then
    echo "Microservice" $name "is underloaded"
    echo "Load is " $p "%"
    service=`echo $name | cut -d '.' -f1`
    echo "Parent Service is: " $service
    creplicas=$(docker service ps $service | grep Running | wc -l)
    echo "Current number of Replicas is: " $creplicas
    replicas=$((creplicas-1))
 
    echo "New Number of Replicas after scale in is: " $replicas
    if [ "$replicas" -ne 0 ]
    then
        (docker service scale -d $service=$replicas)    
    fi
 fi
done
 
 
sleep 10;
done

