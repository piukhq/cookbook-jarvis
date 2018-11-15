include_recipe 'datadog::dd-agent'

group 'systemd-journal' do
  members 'dd-agent'
  append true
  action :create
  notifies :restart, 'service[datadog-agent]'
end

if node.role?('controller') || node.role?('worker')
  group 'docker' do
    members 'dd-agent'
    append true
    action :create
    notifies :restart, 'service[datadog-agent]'
  end
end

service 'datadog-agent' do
  action :nothing
end

directory '/etc/datadog-agent/conf.d/journald.d'

template '/etc/datadog-agent/conf.d/journald.d/conf.yaml' do
  source 'journal.yaml.erb'
  notifies :restart, 'service[datadog-agent]'
end

file '/etc/datadog-agent/conf.d/disk.d/conf.yaml.default' do
  action :delete
end

template '/etc/datadog-agent/conf.d/disk.d/conf.yaml' do
  source 'disk.yaml.erb'
  notifies :restart, 'service[datadog-agent]'
end
