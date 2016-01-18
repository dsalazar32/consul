# Consul by Hashicorp
# Service discovery and configuration made easy.
# https://www.consul.io/

default['consul']['version']        = version = "0.5.2"
default['consul']['source']         = "https://releases.hashicorp.com/consul/%s/consul_%s_linux_amd64.zip" % [version, version]
default['consul']['data_dir']       = "/tmp/consul"
default['consul']['install_prefix'] = "/usr/local/bin"
default['consul']['config_dir']     = "/etc/consul.d"

# Node specific configurations
default['consul']['node']['name']               = nil
default['consul']['node']['bind_addr']          = nil
default['consul']['node']['datacenter']         = nil

# Server specific configurations
default['consul']['server']['cluster_tag']      = "consul-cluster"
default['consul']['server']['bootstrap_expect'] = 3  # Recommended minimum required for quorum is 3
default['consul']['server']['auto_cluster']     = true
default['consul']['server']['bindable_ips']     = [] # If auto_cluster is set to false define bindable ips here
