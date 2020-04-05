FROM centos:8
MAINTAINER admin@dataadnstoragesolutions.com

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum install -y epel-release && yum update -y && yum install -y wget gcc openssl-devel bzip2-devel libffi-devel make

WORKDIR /tmp
RUN curl -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tgz && curl -O https://bootstrap.pypa.io/get-pip.py
RUN chmod +x get-pip.py Python-3.8.2.tgz
RUN tar -xzf ./Python-3.8.2.tgz

WORKDIR /tmp/Python-3.8.2
RUN ./configure --enable-optimizations && make install && ln -s /usr/local/bin/python3.8 /usr/bin/python3.8 && ln -s /usr/local/bin/python3.8 /usr/bin/python3 && ln -s /usr/local/bin/python3.8 /usr/bin/python

WORKDIR /tmp
RUN python get-pip.py && ln -s /usr/local/bin/pip3.8 /usr/bin/pip && pip install -U pip
RUN rm -f ./Python-3.8.2.tgz ./get-pip.py
RUN rm -fr ./Python-3.8.2

RUN wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /usr/local/bin/systemctl
RUN chmod 755 /usr/local/bin/systemctl
RUN yum remove -y epel-release wget make
RUN yum clean all

CMD ["/usr/local/bin/systemctl"]
