#!/bin/bash

# Updates yum 
sudo yum update -y

# Downloads NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# Downloads YARN
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg

# All our yum requirements are in the yum_requirements.txt 
sudo yum install -y $(cat requirements.txt)

# Opens up a port for the VCN
# Now you can access the instance through the public IP address and the port 3000
# i.e. http://129.146.239.245:3000/
sudo firewall-cmd --add-port=3000/tcp
sudo firewall-cmd --permanent --add-port=3000/tcp