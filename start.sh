#!/bin/bash

trap "printf '\nBye.\n'; exit 0;" SIGHUP SIGINT SIGTERM

if [ -z "$ZT_NETWORK_ID" ]; then
    printf "Missing env ZT_NETWORK_ID. Cannot start.\n";
    exit 1;
fi

printf "Running zerotier daemon\n";
zerotier-one &
ZT_PID=$!;
sleep 1;

printf "Starting unbound daemon\n";
nohup unbound &

printf "Joining network $ZT_NETWORK_ID with daemon pid $ZT_PID\n";
zerotier-cli join $ZT_NETWORK_ID;

printf "Setting up iptables\n";
iptables -t nat -A POSTROUTING -j MASQUERADE;

printf "Setting up iproute\n";
# TODO: get route from env var
ip r a 10.0.0.0/8 dev zt0;

printf "\n\
    ZeroTierOne container is now a member and forwarding all the IP packets.\n\
    If you want to access the network, all you need to do is run\n\
    sudo ip r a DOCKER_NETWORK via GET_IP_FROM_ZEROTIER\n"

# printf "Waiting for daemon pid $ZT_PID.\n";
wait $ZT_PID;
