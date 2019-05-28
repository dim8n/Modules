#!/bin/bash
yum -y update
yum -y install httpd
echo "<html><body bgcolor=black><h1><p><font color=red>Web server " > /var/www/html/index.html
curl http://169.254.169.254/latest/meta-data/public-hostname >> /var/www/html/index.html
echo  "</font></p></h1></body>" >> /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
