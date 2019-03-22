#
# Cookbook:: task9_cookbook
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

#package 'docker.io' #for Ubuntu and Mint
package 'docker'

file "/etc/docker/daemon.json" do
    content "{\n\t\"insecure-registries\" : [\"127.0.0.1:5000\"]\n}\n"
end

service 'docker' do
  action [:enable, :start]
end
