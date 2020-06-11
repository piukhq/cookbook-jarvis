package 'prometheus-node-exporter' do
  action :remove
end

group 'node_exporter' do
  system true
end

user 'node_exporter' do
  shell '/usr/sbin/nologin'
  gid 'node_exporter'
  system true
end

directory '/opt/node_exporter' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

unless File.exist?("/opt/node_exporter/#{node['node_exporter']['version']}")
  remote_file 'node_exporter' do
    path "#{Chef::Config[:file_cache_path]}/node_exporter.tar.gz"
    owner 'root'
    group 'root'
    mode '0644'
    source "https://github.com/prometheus/node_exporter/releases/download/v#{node['node_exporter']['version']}/node_exporter-#{node['node_exporter']['version']}.linux-amd64.tar.gz"
    checksum node['node_exporter']['checksum']
  end

  archive_file 'node_exporter' do
    path "#{Chef::Config[:file_cache_path]}/node_exporter.tar.gz"
    destination '/tmp/node_exporter'
  end

  remote_file "/opt/node_exporter/#{node['node_exporter']['version']}" do
    source "file:///tmp/node_exporter/node_exporter-#{node['node_exporter']['version']}.linux-amd64/node_exporter"
    owner 'root'
    group 'root'
    mode '0755'
  end

  directory '/tmp/node_exporter' do
    recursive true
    action :delete
  end

  file "#{Chef::Config[:file_cache_path]}/node_exporter.tar.gz" do
    action :delete
  end
end

link '/usr/local/sbin/node_exporter' do
  to "/opt/node_exporter/#{node['node_exporter']['version']}"
  notifies :restart, 'service[node_exporter]'
end

options = [
  '--collector.diskstats.ignored-devices="^(dm|ram|loop|fd|(h|v|xv)d[a-z]|nvme\\d+n\\d+p)\\d+$"',
  '--collector.filesystem.ignored-mount-points="^/(sys|proc|dev|run)($|/)"',
  # '--collector.ntp',  # Cant use as systemd-timesyncd doesnt listen on 127.0.0.1:123 as rightly, it only implementes NTP client.
  '--collector.systemd',
  '--collector.systemd.unit-whitelist="^(kube).+$"',
]

systemd_unit 'node_exporter.service' do
  content(
    Unit: {
      Description: 'Prometheus exporter for machine metrics',
      Documentation: 'https://github.com/prometheus/node_exporter',
      After: 'network.target',
    },
    Service: {
      Restart: 'always',
      User: 'node_exporter',
      Group: 'node_exporter',
      ExecStart: "/usr/local/sbin/node_exporter #{options.join(" \\\n")}",
      WorkingDirectory: '/',
      RestartSec: '30s',
    },
    Install: {
      WantedBy: 'multi-user.target',
    }
  )
  action [:create, :enable]
  notifies :restart, 'service[node_exporter]'
end

service 'node_exporter' do
  action :nothing
end
