FROM centos

ENV container docker

#PROXY_PLACEHOLDER1
#COPY *.sh /root/
#COPY bashrc /root/.bashrc
#COPY collectd_automated_setup /etc/init.d/

WORKDIR /root

RUN yum -y install epel-release
RUN yum -y install collectd && yum clean all

#RUN yum -y install initscripts; rm /etc/rc.d/rc*.d/*
#RUN mv /etc/init/serial.conf /etc/init/serial.conf.disabled; \
#mv /etc/init/tty.conf /etc/init/tty.conf.disabled; \
#mv /etc/init/start-ttys.conf /etc/init/start-ttys.conf.disabled

#RUN yum install -y --enablerepo=rpmforge-testing collectd collectd-snmp; yum clean all
#RUN chkconfig collectd on; chkconfig --add collectd_automated_setup; chkconfig collectd_automated_setup on
#PROXY_PLACEHOLDER2

CMD ["collectd" "-f"]
