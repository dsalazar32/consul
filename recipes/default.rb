#
# Cookbook Name:: consul
# Recipe:: default
#
# Copyright (C) 2015 David Salazar
#
# All rights reserved - Do Not Redistribute
#

package "unzip"

dwnlddir = Chef::Config['file_cache_path']
download = node['consul']['source']
confgdir = node['consul']['config_dir']
filename = download.split('/').last
prefix   = node['consul']['install_prefix']

remote_file ::File.join(dwnlddir, filename) do
  source download
end

execute "extract_consul_package" do
  cwd dwnlddir
  command "unzip #{filename} -d #{prefix}"
  notifies :create, "directory[#{confgdir}]", :immediately
  not_if { ::File.exists?(::File.join(prefix, 'consul')) }
end

directory confgdir do
  action :nothing
  recursive true
  owner "root"
  group "root"
end
