# frozen_string_literal: true

# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version '>= 1.8.3'

Vagrant.configure(2) do |config|
  ram = 1024
  cpu = 1

  guest_port = 8093
  host_port  = 8093
  ip         = '192.168.33.13'

  # Development VM
  config.vm.define 'dev', primary: true do |dev|
    vm = dev.vm

    vm.provider 'virtualbox' do |v|
      v.memory = ram
      v.cpus   = cpu
      v.customize ['modifyvm', :id, '--audio', 'none']
    end
    vm.box             = 'ubuntu/bionic64'
    vm.hostname        = 'post-ratings'
    vm.post_up_message = <<-MESSAGE
      Ready to development. Use 'vagrant ssh' to connect to virtual machine
      Application will be avalible on
      http://#{ip}:#{host_port}"
    MESSAGE

    dev.ssh.forward_agent = true

    vm.network 'private_network', ip: ip
    vm.network 'forwarded_port',  guest: guest_port, host: host_port

    vm.provision :ansible_local do |ansible|
      ansible.provisioning_path = '/vagrant/ansible'
      ansible.playbook          = 'main.yml'
      ansible.inventory_path    = 'inventory/local.ini'
      ansible.limit             = 'local'
      ansible.galaxy_roles_path = 'roles'
      ansible.galaxy_role_file  = 'requirements.yml'
    end
  end

  # Use vagrant-cachier to cache apt-get, gems and other stuff across machines
  config.cache.scope = :box if Vagrant.has_plugin?('vagrant-cachier')
end
