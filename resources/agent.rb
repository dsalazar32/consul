property :options,kind_of: Hash, default: {}
property :download, kind_of: String, default: node['consul']['source']
property :data_dir, kind_of: String, default: "/tmp/consul"
property :config_dir, kind_of: String, default: "/etc/consul.d"
property :prefix, kind_of: String, default: "/usr/local/bin"
property :pidfile, kind_of: String, default: "/var/run/consul.pid"

default_action :create

action :create do
  include_recipe "runit::default"
  package "unzip"

  dwnldpth = Chef::Config['file_cache_path']
  filename = download.split('/').last

  remote_file ::File.join(dwnldpth, filename) do
    source download
  end

  execute "extract_consul_package" do
    cwd dwnldpth
    command "unzip #{filename} -d #{prefix}"
    notifies :create, "directory[/etc/consul.d]", :immediately
    not_if { ::File.exists?(::File.join(prefix, 'consul')) }
  end

  directory config_dir do
    action :nothing
    recursive true
    owner "root"
    group "root"
  end

  # Default configurations
  # https://www.consul.io/docs/agent/options.html#configuration_files
  default_opts = { 
    opts: {
      data_dir: "/opt/consul"
    } 
  }

  template ::File.join(config_dir, 'consul.json') do
    cookbook "consul"
    source   "abstract.json.erb"
    variables default_opts
    not_if { !::Dir.exists?(config_dir)  }
  end

  runit_service "consul" do
    action   :nothing
    cookbook "consul"
  end

end
