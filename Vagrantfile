# -*- mode: ruby -*-
# vi: set ft=ruby :

# CentOSでsingle-request-reopenを有効にする
initialize = <<-EOT
  if [ ! $(grep single-request-reopen /etc/sysconfig/network) ]; then
    echo RES_OPTIONS=single-request-reopen >> /etc/sysconfig/network && service network restart;
  fi
EOT

# アプリの設定を記載したファイルの読み込み
require_relative "vm_env"

Vagrant.configure(2) do |config|
  vm_env = VmEnv.new config

  config.vm.box = "bento/centos-6.7"

  # ポート設定
  vm_env.port

  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder "./", "/vagrant", id: "vagrant", :nfs => false, :mount_options => ["dmode=777","fmode=666"]

  # VM option
  config.vm.provider "virtualbox" do |v|
    v.name = "dev-server"
    v.customize ["modifyvm", :id, "--nictype1", "virtio"]
    v.customize ["modifyvm", :id, "--nictype2", "virtio"]
    # ホスト側の時刻と同期
    v.customize ["setextradata", :id, "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled", 0]
  end

  config.vm.provision "shell", inline: initialize

  # プロビジョニング
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "provision/playbook.yml"
    ansible.verbose = "vvv"
  end

  config.vm.provision :serverspec do |spec|
    spec.pattern = "spec/default/*_spec.rb"
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

end
