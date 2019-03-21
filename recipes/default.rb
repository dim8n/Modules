#
# Cookbook:: task9-cookbook
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
#file "#{ENV['HOME']}/hello.txt" do
#  content 'This file was created by Chef and Dimon)!'
#end
package 'docker.io'
package 'docker'

