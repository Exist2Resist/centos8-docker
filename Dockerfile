FROM centos:8
MAINTAINER admin@dataadnstoragesolutions.com

RUN yum install wget python3 -y && ln -s /usr/bin/python3.6 /usr/bin/python && yum clean all
RUN wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /usr/local/bin/systemctl \
&& chmod 755 /usr/local/bin/systemctl

CMD ["/usr/local/bin/systemctl"]
