include_recipe "consul::server"

auto_cluster     = node['consul']['server']['auto_cluster']
cluster_tag      = node['consul']['server']['cluster_tag']
bindable_ips     = node['consul']['server']['bindable_ips']
bootstrap_expect = node['consul']['server']['bootstrap_expect']
node_ipaddress   = node['ipaddress']

nodes = if Chef::Config[:solo] && bindable_ips.empty?
          Chef::Log.warn("Auto clustering feature requires search which is unavailable in Chef Solo."); []
        elsif bindable_ips.any?
          if bindable_ips.length < bootstrap_expect
            Chef::Log.warn("Bindable ips count must match bootstrap count expectations."); []
          else
            bindable_ips
          end
        else
          results = search(:node, "tags:#{cluster_tag} AND chef_environment:#{node.chef_environment}")
          results.map(&:ipaddress) << node_ipaddress
        end

execute "cluster_nodes" do
  command "consul join #{nodes.join(' ')}"
  user    "root"
  retries 3
  retry_delay 5
  only_if { auto_cluster && bootstrap_expect == nodes.length }
end
