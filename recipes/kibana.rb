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
