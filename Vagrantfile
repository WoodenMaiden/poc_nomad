# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  ENV['DEBIAN_FRONTEND'] = "noninteractive"
  ENV['NOMAD_ADDR'] = "http://localhost:4646"

  N_CLIENTS = 3
  BASE_IP = "123.123.123"
  TOKEN = rand(36**20).to_s(36) # 20 character random string

  config.vm.box = "debian/buster64"

  config.vm.provision :shell, inline: <<-SHELL
    if [ ! -d /etc/docker ]; then
      mkdir /etc/docker
    fi
    echo '{ "insecure-registries": [ "10.9.2.21:8080" ] }' > /etc/docker/daemon.json
  SHELL

  config.vm.provision :ansible do |ansible|
    ansible.verbose = "vv"

    ansible.playbook = "site.yaml"
    ansible.compatibility_mode = "2.0"

    client_group_members = (1..N_CLIENTS).map { |i| "nomad-client#{i}" }
    instances = client_group_members + ["nomad-server"]

    ansible.groups = {
      "client" => client_group_members,
      "server" => ["nomad-server"],
      "nomad_instances" => instances,
      "consul_instances" => instances,
      "consul_instances:vars" => {
        "consul_acl_token" => TOKEN,
      },
      "client:vars" => {
        "nomad_node_role" => "client",

        "consul_node_role" => "client",
        "consul_acl_enable" => true,
      },
      "server:vars" => {
        "nomad_node_role" => "server",
        "nomad_advertise_address" => "#{BASE_IP}.254",
        "nomad_consul_address" => "#{BASE_IP}.254",

        "consul_acl_enable" => true,
        "consul_node_role" => "bootstrap",
        "consul_advertise_address" => "#{BASE_IP}.254",
      }
    }
  end

  config.vm.define "nomad-server" do |server|
    server.vm.hostname = "nomad-server"
    server.vm.network "forwarded_port", guest: 4646, host: 4646
    server.vm.network "forwarded_port", guest: 8500, host: 8500
    server.vm.network "private_network", ip: "#{BASE_IP}.254"
  end

  (1..N_CLIENTS).each do |i|
    config.vm.define "nomad-client#{i}" do |client|
      client.vm.hostname = "nomad-client#{i}"
      client.vm.network "private_network", ip: "#{BASE_IP}.#{i+1}"
    end
  end
end
