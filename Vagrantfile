# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  ENV['DEBIAN_FRONTEND'] = "noninteractive"
  ENV['NOMAD_ADDR'] = "http://localhost:4646"

  N_CLIENTS = 3

  config.vm.box = "debian/buster64"

  config.vm.network "private_network", type: "dhcp"

  config.vm.provision :ansible do |ansible|

    ansible.playbook = "site.yaml"
    ansible.compatibility_mode = "2.0"

    client_group_members = (1..N_CLIENTS).map { |i| "nomad-client#{i}" }

    ansible.groups = {
      "client" => client_group_members,
      "server" => ["nomad-server"],
      "nomad_instances" => client_group_members + ["nomad-server"], 
      "client:vars" => {
        "nomad_node_role" => "client"
      },
      "server:vars" => {
        "nomad_node_role" => "server"
      },
    }
  end

  config.vm.define "nomad-server" do |server|
    server.vm.hostname = "nomad-server"
    server.vm.network "forwarded_port", guest: 4646, host: 4646
    server.vm.network "forwarded_port", guest: 8500, host: 8500
  end

  (1..N_CLIENTS).each do |i|
    config.vm.define "nomad-client#{i}" do |client|
      client.vm.hostname = "nomad-client#{i}"
    end
  end
end
