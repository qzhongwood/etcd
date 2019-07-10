#!/usr/bin/env bash

set -e
BASE_PORT=2300

index=3
CLUSTER="vp0=http://0.0.0.0:2380,vp1=http://0.0.0.0:2480,vp2=http://0.0.0.0:2580,vp3=http://0.0.0.0:2680"

restart() {
    /killbyname.sh etcd-data${index}
    sleep 3

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

    sleep 3

    etcdctl --endpoints=127.0.0.1:2679 get foo
}

for ((;;)) do
    restart
done