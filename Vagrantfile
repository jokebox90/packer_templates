Vagrant.configure("2") do |config|
  config.ssh.username = 'vagrant'
  config.ssh.forward_agent = true
  config.ssh.private_key_path = "./ssh/id_vagrant"

  config.vm.box = "file://builds/debian-10.3.virtualbox.box"
  config.vm.provision "shell", inline: "echo I am provisioning at $(date) ..."

  config.vm.define "debian-10" do |instance|
    instance.vm.network :private_network, ip: "10.22.1.10"
    instance.vm.network "forwarded_port", guest: 22, host: 10022

    instance.ssh.host = "127.0.0.1"
    instance.ssh.port = "10022"

    # instance.vm.hostname = "debian-10"

    instance.vm.provider :virtualbox do |machine|
      machine.name   = "vagrant-debian-10"
      machine.gui    = false
      machine.memory = 4096
      machine.cpus   = 2
      machine.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      machine.customize ["modifyvm", :id, "--ioapic", "on"]
    end
  end  

end