# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  ENV['DEBIAN_FRONTEND'] = "noninteractive"
  ENV['NOMAD_ADDR'] = "http://localhost:4646"

  config.vm.box = "debian/bookworm64"

  # config.vm.provision :ansible do |ansible|
  #   ansible.inventory_path = "vagrant_ansible_inventory"

  #   ansible.playbook = "install_runtimes.yaml"
  # end

  config.vm.define "nomad-server" do |server|
    server.vm.hostname = "nomad-server"
    server.vm.network "forwarded_port", guest: 4646, host: 8081
    server.vm.network "private_network", ip: "123.123.123.254"

  end

  (1..3).each do |i|
    config.vm.define "nomad-client#{i}" do |client|
      client.vm.hostname = "nomad-client#{i}"
      client.vm.network "private_network", ip: "123.123.123.#{i}"
    end
  end
end
