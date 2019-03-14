FROM centos

RUN echo "[grafana]" >> /etc/yum.repos.d/grafana.repo;\
    echo "name=grafana" >> /etc/yum.repos.d/grafana.repo;\
    echo "baseurl=https://packages.grafana.com/oss/rpm" >> /etc/yum.repos.d/grafana.repo;\
    echo "repo_gpgcheck=1" >> /etc/yum.repos.d/grafana.repo;\
    echo "enabled=1" >> /etc/yum.repos.d/grafana.repo;\
    echo "gpgcheck=1" >> /etc/yum.repos.d/grafana.repo;\
    echo "gpgkey=https://packages.grafana.com/gpg.key" >> /etc/yum.repos.d/grafana.repo;\
    echo "sslverify=1" >> /etc/yum.repos.d/grafana.repo;\
    echo "sslcacert=/etc/pki/tls/certs/ca-bundle.crt" >> /etc/yum.repos.d/grafana.repo

RUN yum install -y grafana && yum clean all
#RUN firewall-cmd --add-port=3000/tcp --permanent && firewall-cmd --reload

WORKDIR /usr/share/grafana

#RUN cd /usr/share/grafana && grafana-cli admin --config=/etc/grafana/grafana.ini
#RUN cd /usr/share/grafana && /usr/sbin/grafana-server --config=/etc/grafana/grafana.ini

#EXPOSE 3000

#USER root

CMD ["/usr/sbin/grafana-server","--config=/etc/grafana/grafana.ini"]
#CMD ["systemctl", "start", "grafana-server"]
#CMD ["/usr/bin/bash"]
