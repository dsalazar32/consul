include_recipe "consul::default"
include_recipe "runit::default"

confgdir = node['consul']['config_dir']

# Default configurations
# https://www.consul.io/docs/agent/options.html#configuration_files
agent_opts = {
  opts: {
    data_dir: "/opt/consul",
    server: true,
    bootstrap_expect: node['consul']['server']['bootstrap_expect']
  }
}

template ::File.join(confgdir, 'server.json') do
  cookbook "consul"
  source "abstract.json.erb"
  variables agent_opts
  not_if { !::Dir.exists?(confgdir) }
end

runit_service "consul" do
  cookbook "consul"
end
