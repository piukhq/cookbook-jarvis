control 'node_exporter' do
  impact 1.0
  title 'Check node_exporter'
  describe file('/usr/local/sbin/node_exporter') do
    it { should exist }
  end

  describe systemd_service('node_exporter') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe port(9100) do
    it { should be_listening }
    its('processes') { should include 'node_exporter' }
    its('protocols') { should include 'tcp' }
  end
end
