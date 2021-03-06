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
