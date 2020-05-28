package 'prometheus-node-exporter'

service 'prometheus-node-exporter' do
  action [:enable, :start]
end
