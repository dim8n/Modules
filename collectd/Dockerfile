FROM centos

RUN yum -y install epel-release
RUN yum -y install collectd && yum clean all

CMD ["/usr/sbin/collectd", "-f"]
