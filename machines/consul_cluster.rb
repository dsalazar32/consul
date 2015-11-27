require "chef/provisioning/vagrant_driver"
require "chef/provisioning"

vagrant_box "precise64" do
  url "http://files.vagrantup.com/precise64.box"
end

with_driver "vagrant"

with_machine_options :vagrant_options => {
   "vm.box" => "precise64"
}

machine "consul" do
  tag "consul-cluster"
  converge true
end
