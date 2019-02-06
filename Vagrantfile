Vagrant.configure("2") do |config|
	config.vm.box = "bento/centos-7.5"
	config.vm.provider "virtualbox" do |vb|
		vb.gui = false
		vb.memory = 512
		vb.cpus = 2
	end

	config.vm.define "server1" do |server1|
		server1.vm.hostname = "server1"
		server1.vm.network "private_network", ip: "192.168.0.10"
		server1.vm.provision "shell", inline: <<-SHELL
			yum install git -y -q
			if [ -d /git/ ]; then
				rm -Rf /git/
			fi
			mkdir /git
			chown vagrant /git
			chmod -R 775 /git
			cd /git
			git clone http://github.com/dim8n/Module2.git -b task2 -q
			cd /git/Module2
			cat /git/Module2/test.txt
			if ! [ -f /home/vagrant/.ssh/id_rsa_srv1 ]; then
				sudo -u vagrant ssh-keygen -t rsa -q -N '' -f /home/vagrant/.ssh/id_rsa
				cp -f -v /home/vagrant/.ssh/id_rsa.pub /vagrant/id_rsa_srv1.pub
			fi
			if [ -f /vagrant/id_rsa_srv2.pub ]; then
				grep -q 'vagrant@server2' /home/vagrant/.ssh/authorized_keys || sudo -u vagrant cat /vagrant/id_rsa_srv2.pub >> /home/vagrant/.ssh/authorized_keys
				chmod 600 /home/vagrant/.ssh/authorized_keys
				chmod 700 /home/vagrant/.ssh/
			fi
		SHELL
	end

	config.vm.define "server2" do |server2|
		server2.vm.hostname = "server2"
		server2.vm.network "private_network", ip: "192.168.0.11"
		server2.vm.provision "shell", inline: <<-SHELL
			if ! [ -f /home/vagrant/.ssh/id_rsa_srv2.pub ]; then
				sudo -u vagrant ssh-keygen -t rsa -q -N '' -f /home/vagrant/.ssh/id_rsa
				cp -f -v /home/vagrant/.ssh/id_rsa.pub /vagrant/id_rsa_srv2.pub
			fi
			if [ -f /vagrant/id_rsa_srv1.pub ]; then
				grep -q 'vagrant@server1' /home/vagrant/.ssh/authorized_keys || sudo -u vagrant cat /vagrant/id_rsa_srv1.pub >> /home/vagrant/.ssh/authorized_keys
				chmod 600 /home/vagrant/.ssh/authorized_keys
				chmod 700 /home/vagrant/.ssh/
			fi
		SHELL
	end

	config.vm.provision "shell", inline: <<-SHELL
		grep -q '192.168.0.[10-11]' '/etc/hosts' && echo "++++ hosts file is good ++++" || echo "192.168.0.10 server1\n192.168.0.11 server2\n" >> /etc/hosts;
	SHELL

end
