include_recipe 'datadog::dd-agent'

directory '/etc/datadog-agent/conf.d/journald.d'

file '/etc/datadog-agent/conf.d/journald.d/conf.yaml' do
  action :create
  content "logs:\n  - type: journald\n    path: /run/log/journal"
end
