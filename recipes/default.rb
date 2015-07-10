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

template '/etc/elasticsearch/elasticsearch.yml' do
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart, "service[elasticsearch]"
end

service "elasticsearch" do
  supports :status => true, :restart => true
  action [:enable, :start]
end

kibana_tar = '/tmp/kibana.tar.gz'

remote_file kibana_tar do
  source 'https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz'
  action :create
end

bash 'extract_kibana' do
  cwd ::File.dirname(kibana_tar)
  code <<-EOH
    tar xvf kibana.tar.gz
    rm kibana*/config/kibana.yml
    sudo mkdir -p /opt/kibana
    sudo cp -R kibana-4*/* /opt/kibana/
    rm -rf kibana*/
  EOH
end

remote_file '/etc/init.d/kibana' do
  source 'https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/bce61d85643c2dcdfbc2728c55a41dab444dca20/kibana4'
  mode '777'
  action :create
end

template '/opt/kibana/config/kibana.yml' do
  notifies :restart, "service[kibana]"
end

service 'kibana' do
  supports :status => true, :restart => true
  action [:enable, :start]
end



package "nginx"
package "apache2-utils"

template '/etc/nginx/sites-available/default' do
  source 'nginx.erb'
  notifies :reload, "service[nginx]"
  action :create
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
