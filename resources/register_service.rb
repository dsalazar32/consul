resource_name :consul_register_service

property :service_name, kind_of: String, name_property: true, required: true
property :confgdir, kind_of: String, default: node['consul']['config_dir']
property :tags, kind_of: Array, default: nil
property :address, kind_of: String, default: nil 
property :port, kind_of: Fixnum, default: nil

default_action :create

action :create do
  include_recipe "consul::agent"

  register = {opts: {service: {}}}
  register[:opts][:service].tap do |svc|
    svc[:name]    = service_name
    svc[:tags]    = tags unless tags.nil?
    svc[:address] = address unless address.nil?
    svc[:port]    = port unless port.nil?
  end

  template ::File.join(confgdir, "#{service_name}.json") do
    cookbook "consul"
    source "abstract.json.erb"
    variables register 
    notifies :reload, "runit_service[consul]", :delayed
    not_if { !::Dir.exists?(confgdir) }
  end

  runit_service "consul" do
    cookbook "consul"
  end
end
