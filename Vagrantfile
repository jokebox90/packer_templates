# - Variables
vm_project_path = ENV['VM_PROJECT_PATH']

# - Hardware
vm_box = "#{vm_project_path}/builds/debian-10.9.virtualbox.box"
vm_vcpus = 2
vm_memory = 2048

# - Environment
vm_basename = 'debian-10'
vm_username = 'ansible'
vm_password = '4Ns1Bl3!'

# - Network
vm_network_prefix = '192.168.106'
vm_ssh_forward_agent = true

# - Provisioning
vm_provision = <<~SCRIPT
  this_date=$(date)
  echo I am provisioning at $this_date ...
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = vm_box
  config.ssh.username = vm_username
  config.ssh.password = vm_password
  config.ssh.forward_agent = vm_ssh_forward_agent
  config.ssh.private_key_path = "#{vm_project_path}/ssh/id_ansible"

  config.vm.provision "shell", inline: vm_provision

  config.vm.define "#{vm_basename}" do |instance|
    instance.vm.hostname = "#{vm_basename}"
    instance.vm.network "private_network", ip: "#{vm_network_prefix}.150"

    instance.vm.provider :virtualbox do |machine|
      machine.name   = "vagrant-#{vm_basename}"
      machine.gui    = false
      machine.memory = vm_memory
      machine.cpus   = vm_vcpus
      machine.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      machine.customize ["modifyvm", :id, "--ioapic", "on"]
    end
  end

end