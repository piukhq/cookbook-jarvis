include_recipe 'datadog::dd-agent'

group 'systemd-journal' do
  members 'dd-agent'
  append true
  action :create
  notifies :restart, 'service[datadog-agent]'
end

service 'datadog-agent' do
  action :nothing
end

directory '/etc/datadog-agent/conf.d/journald.d'

file '/etc/datadog-agent/conf.d/journald.d/conf.yaml' do
  action :create
  content "logs:\n  - type: journald\n"
  notifies :restart, 'service[datadog-agent]'
end
