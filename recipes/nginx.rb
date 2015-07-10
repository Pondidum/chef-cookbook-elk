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
