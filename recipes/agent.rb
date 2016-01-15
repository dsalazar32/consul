include_recipe "consul::default"
include_recipe "runit::default"

confgdir = node['consul']['config_dir']

# Default configurations
# https://www.consul.io/docs/agent/options.html#configuration_files
agent_opts = { opts: {} }
agent_opts[:opts].tap do |options|
  options[:node_name]  = node['consul']['node']['name']           if node['consul']['node']['name']
  options[:bind_addr]  = node['consul']['node']['bind_addr']      if node['consul']['node']['bind_addr']
  options[:start_join] = node['consul']['server']['bindable_ips'] if node['consul']['server']['bindable_ips']
  options[:data_dir]   = "/opt/consul"
  options[:leave_on_terminate] = true
end

template ::File.join(confgdir, 'agent.json') do
  cookbook "consul"
  source "abstract.json.erb"
  variables agent_opts
  not_if { !::Dir.exists?(confgdir) }
end


runit_service "consul" do
  cookbook "consul"
end
