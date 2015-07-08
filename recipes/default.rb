#
# Cookbook Name:: elk
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'java'

apt_repository 'elasticsearch' do
  uri "http://packages.elastic.co/elasticsearch/1.6/debian"
  components ["stable", "main"]
  key "https://packages.elastic.co/GPG-KEY-elasticsearch"
  action :add
end

package "elasticsearch"

service "elasticsearch" do
  action [:enable, :start]
end
