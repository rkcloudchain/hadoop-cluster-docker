#!/bin/bash

# the default node number is 5
N=${1:-6}


# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
				-p 9000:9000 \
                -p 8088:8088 \
				-v /data/hdfs/namenode:/root/hdfs/namenode \
                --name hadoop-master \
                --hostname hadoop-master \
                reg.querycap.com/cloudchain/hadoop:1.0 &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
	                --net=hadoop \
					-p 50010:50010 \
					-v /data/hdfs/datanode$i:/root/hdfs/datanode \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                reg.querycap.com/cloudchain/hadoop:1.0 &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash
