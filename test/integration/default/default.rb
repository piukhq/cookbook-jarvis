describe package('prometheus-node-exporter') do
  it { should be_installed }
end

describe systemd_service('prometheus-node-exporter') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
