include_recipe 'datadog::dd-handler'
include_recipe 'datadog::dd-agent'

ddowner = 'dd-agent'
ddgroup = 'dd-agent'

group 'systemd-journal' do
  members 'dd-agent'
  append true
  action :create
  notifies :restart, 'service[datadog-agent]'
end

service 'datadog-agent' do
  action :nothing
end

directory '/etc/datadog-agent/conf.d/journald.d' do
  owner ddowner
  group ddgroup
end

template '/etc/datadog-agent/conf.d/journald.d/conf.yaml' do
  source 'journal.yaml.erb'
  owner ddowner
  group ddgroup
  notifies :restart, 'service[datadog-agent]'
end

file '/etc/datadog-agent/conf.d/disk.d/conf.yaml.default' do
  action :delete
end

template '/etc/datadog-agent/conf.d/disk.d/conf.yaml' do
  source 'disk.yaml.erb'
  owner ddowner
  group ddgroup
  notifies :restart, 'service[datadog-agent]'
end
