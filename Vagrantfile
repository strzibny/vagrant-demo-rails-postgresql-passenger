VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "fedora21"

  #config.ssh.insert_key = false
  config.ssh.forward_agent = true

  # primary makes it default for commands like vagrant ssh
  config.vm.define "web", primary: true do |web|
    web.vm.network "private_network", ip: "192.168.142.102", :libvirt__network_name => "demo"

    # Get the missing packages
    web.vm.provision :shell, path: 'vagrant.sh'

    # Synced folder
    web.vm.synced_folder ".", "/vagrant", type: "nfs"

    # Run production server
    web.vm.provision :shell, inline: <<SHELL
cd /vagrant
su - vagrant -c 'cd /vagrant;RAILS_ENV=production rake db:create'
su - vagrant -c 'cd /vagrant;RAILS_ENV=production rake db:migrate'
sudo gem install passenger
sudo /usr/local/bin/passenger start --daemonize --port 3001 --user vagrant --environment production
SHELL

    # Forward ports for development and production ENV
    web.vm.network "forwarded_port", guest: 3000, host: 3000
    web.vm.network "forwarded_port", guest: 3001, host: 3001
  end

  config.vm.define "db" do |db|
    db.vm.network "private_network", ip: "192.168.142.101", :libvirt__network_name => "demo"

    # Install and configure production database
    db.vm.provision :shell, inline: <<SHELL
sudo yum install postgresql-server -y
sudo postgresql-setup initdb

echo '# "local" is for Unix domain socket connections only
local all all trust
# IPv4 local connections:
host all all 0.0.0.0/0 trust
# IPv6 local connections:
host all all ::/0 trust' | sudo tee /var/lib/pgsql/data/pg_hba.conf
#sudo sed -i "listen_addresses = 'localhost'/listen_addresses = '*'/g" /home/vagrant/data/postgresql.conf
echo "listen_addresses = '*'" | sudo tee /var/lib/pgsql/data/postgresql.conf
sudo systemctl enable postgresql
sudo systemctl restart postgresql
sudo su - postgres -c 'createuser -s vagrant' || : 
SHELL

  end
end
