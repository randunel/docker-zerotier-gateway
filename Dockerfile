FROM randunel/zerotierone:1.1.6

USER root

RUN apt-get update && \
    apt-get install -y unbound iptables

ADD unbound.conf /etc/unbound/unbound.conf
ADD start.sh /root/start.sh

ENTRYPOINT ["/root/start.sh"]
