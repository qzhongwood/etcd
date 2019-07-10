#!/usr/bin/env bash

NODE_NUM=4
BASE_PORT=2300


/killbyname.sh etcd

rm -rf ./etcd-data*
rm ./etcd*.log

CLUSTER="vp0=http://0.0.0.0:2380,vp1=http://0.0.0.0:2480,vp2=http://0.0.0.0:2580,vp3=http://0.0.0.0:2680"

for ((index=0; index<$NODE_NUM; index++)) do
    ((client_port = BASE_PORT + index*100 + 79))
    ((peer_port = client_port + 1))

    nohup etcd \
    --name vp${index}  \
    --data-dir ./etcd-data${index} \
    --listen-client-urls http://0.0.0.0:${client_port},http://127.0.0.1:$client_port \
    --advertise-client-urls http://0.0.0.0:$client_port \
    --initial-advertise-peer-urls http://0.0.0.0:$peer_port \
    --listen-peer-urls http://0.0.0.0:$peer_port \
    --initial-cluster-token etcd-cluster \
    --initial-cluster ${CLUSTER} \
    --initial-cluster-state new 2>&1 >etcd${index}.log &
    
done