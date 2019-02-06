$TOMCAT_COUNT = 2
$subnetwork_net = "192.168.0."

Vagrant.configure("2") do |config|
	config.vm.box = "bento/centos-7.5"
	config.vm.box_check_update=false
	config.vm.provider "virtualbox" do |vb|
		vb.gui = false
		vb.memory = 256
		vb.cpus = 2
		vb.check_guest_additions=false
	end

	File.open("workers.properties", "w") do |f|			#generating worker.properties file
		f.write("worker.list=myworker\n")
		f.write("\n")
		for i in 1..$TOMCAT_COUNT
			f.write("worker.myworker#{i}.port=8009\n")
			f.write("worker.myworker#{i}.host=inserver#{i}\n")
			f.write("worker.myworker#{i}.type=ajp13\n")
			f.write("\n")
		end
		f.write("worker.myworker.type=lb\n")
		f.write("\n")
		f.write("worker.myworker.balance_workers=myworker1")
		for i in 2..$TOMCAT_COUNT
			f.write(",myworker#{i}")
		end
		f.write("\n")
		f.close
	end

	File.open("httpd_mod_jk.conf", "w") do |f|			#generating httpd_mod_jk.conf file
		f.write("LoadModule jk_module modules/mod_jk.so\n")
		f.write("JkWorkersFile conf/workers.properties\n")
		f.write("JkShmFile /tmp/shm\n")
		f.write("JkLogFile logs/mod_jk.log\n")
		f.write("JkLogLevel info\n")
		f.write("JkMount /app1/* myworker\n")
		f.write("\n")
		f.close
	end

	File.open("hosts", "w") do |f|			#generating hosts file
		f.write("127.0.0.1 localhost\n")
		f.write("#{$subnetwork_net}10 frontserver1\n")
		for i in 1..$TOMCAT_COUNT
			f.write("#{$subnetwork_net}#{10+i} inserver#{i}\n")
		end
		f.write("\n")
		f.close
	end

	config.vm.define "frontserver1" do |server1|
		server1.vm.hostname = "frontserver1"
		server1.vm.network "private_network", ip: "#{$subnetwork_net}10"
		server1.vm.network "forwarded_port", guest: 80, host: 8400
		server1.vm.provision "shell", inline: <<-SHELL
			yum install httpd -y -q
			cp -f /vagrant/mod_jk.so /etc/httpd/modules/
			chmod 755 /etc/httpd/modules/mod_jk.so
			cp -f /vagrant/httpd_mod_jk.conf /etc/httpd/conf.d/
			cp -f /vagrant/workers.properties /etc/httpd/conf/
			systemctl enable httpd
			systemctl stop httpd
			systemctl start httpd
		SHELL
	end

	(1..$TOMCAT_COUNT).each do |i|
		config.vm.define "inserver#{i}" do |node|
			node.vm.hostname = "inserver#{i}"
			node.vm.network "private_network", ip: "#{$subnetwork_net}#{10+i}"
			node.vm.provision "shell", inline: <<-SHELL
				yum install java-1.8.0-openjdk -y -q
				yum install tomcat tomcat-webapps tomcat-admin-webapps -y -q
				mkdir /usr/share/tomcat/webapps/app1/
				echo "Tomcat server#{i}" > /usr/share/tomcat/webapps/app1/index.html
				systemctl enable tomcat
				systemctl start tomcat
			SHELL
		end
	end

	config.vm.provision "shell", inline: <<-SHELL
		cp -f /vagrant/hosts /etc/;
	SHELL

end
