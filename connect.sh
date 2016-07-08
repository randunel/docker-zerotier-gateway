#!/bin/bash

if [ -z "$ZT_NETWORK_ID" ]; then
    printf "Missing env ZT_NETWORK_ID.\n"
    exit 1;
fi

if [ -z "$ZT_NETWORK_ID" ]; then
    printf "Missing env DOCKER_NETWORK_NAME.\n"
    exit 1;
fi

sudo zerotier-cli join $ZT_NETWORK_ID;

DOCKER_SUBNET=$(docker network inspect -f "{{range .IPAM.Config}}{{.Subnet}}{{end}}" $DOCKER_NETWORK_NAME)
ZT_DEVICE=$(sudo zerotier-cli listnetworks | grep $ZT_NETWORK_ID | grep -o 'zt[[:digit:]]\+')

# sudo ip r a $DOCKER_SUBNET dev $ZT_DEVICE
# sudo iptables -t nat -A POSTROUTING -o $ZT_DEVICE -j MASQUERADE

# trap "sudo ip r d $DOCKER_SUBNET dev $ZT_DEVICE;" SIGHUP SIGINT SIGTERM

docker pull randunel/zerotier-gateway
docker run --privileged --rm --net=ub_london --name zerotier_gateway -e "ZT_NETWORK_ID=$ZT_NETWORK_ID" randunel/zerotier-gateway

