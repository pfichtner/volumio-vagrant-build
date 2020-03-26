$script = <<-SCRIPT
sudo -E apt update && apt install -y git git squashfs-tools kpartx multistrap qemu-user-static samba debootstrap parted dosfstools qemu binfmt-support qemu-utils md5deep
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "generic/debian9"
  config.vm.provision "shell", inline: $script
end


