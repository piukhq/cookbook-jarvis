service 'datadog-agent' do
  action [:stop, :disable]
end

package 'datadog-agent' do
  action :remove
end
