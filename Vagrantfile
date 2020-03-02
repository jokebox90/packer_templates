Vagrant.configure("2") do |config|
  config.vm.box = "file://builds/debian-10.3.virtualbox.box"

  config.ssh.username = 'vagrant'
  config.ssh.password = 'vagrant'
  config.ssh.insert_key = true
  config.ssh.forward_agent = true

  # config.vm.synced_folder '.', '/vagrant', disable: true

  # config.vm.provision "shell", inline: '/bin/bash /vagrant/scripts/vagrant_provisioned_at.sh'

  # Node 3
  config.vm.define "node3" do |instance|
    instance.vm.hostname = "node3"
    instance.vm.network :private_network, ip: "10.0.42.30"

    instance.vm.provider :virtualbox do |machine|
      machine.name   = 'node3'
      machine.gui    = false
      machine.memory = 4096
      machine.cpus   = 2
      machine.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      machine.customize ["modifyvm", :id, "--ioapic", "on"]
    end
  end  

  # Node 2
  config.vm.define "node2" do |instance|
    instance.vm.hostname = "node2"
    instance.vm.network :private_network, ip: "10.0.42.20"

    instance.vm.provider :virtualbox do |machine|
      machine.name   = 'node2'
      machine.gui    = false
      machine.memory = 4096
      machine.cpus   = 2
      machine.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      machine.customize ["modifyvm", :id, "--ioapic", "on"]
    end
  end  

  # Node 1 - Ansible provisioner
  config.vm.define "node1" do |instance|
    instance.vm.hostname = "node1"
    instance.vm.network :private_network, ip: "10.0.42.10"
    config.vm.synced_folder '.', '/vagrant'

    instance.vm.provider :virtualbox do |machine|
      machine.name   = 'node1'
      machine.gui    = false
      machine.memory = 4096
      machine.cpus   = 2
      machine.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      machine.customize ["modifyvm", :id, "--ioapic", "on"]
    end

    # instance.vm.provision "shell", inline: 'sudo -E -S /bin/bash /vagrant/scripts/ansible.sh'
    # instance.vm.provision "ansible_local" do |ansible|
    #   ansible.provisioning_path = '/vagrant'
    #   ansible.inventory_path = '/vagrant/inventory/'
    #   ansible.playbook = 'dnsmasq.yml'
    #   ansible.limit = 'all'
    # end
  end
end