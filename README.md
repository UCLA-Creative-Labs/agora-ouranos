# Agora - Ouranos (Backend Implementation)

In ancient Greek, the word ```agora``` means a public open space for gathering. In a day in age where COVID-19 has prohibited physical gatherings, we, at Creative Labs, have created a platform for individuals to gather around: ```Agora```. ```Agora``` is a collaborative canvas centered around community. We built it so that every individual can only contribute one stroke at a time with the hope that people would come together to build something amazing. 

This repository is dedicated to the backend architecture of ```Agora``` which we dubbed after the sky titan **Ouranos**. Much like how the sky is an integral part of our lives that we all take for granted, our backend models a similar ideology. As the father of titans and the husband of Gaia (frontend), **Ouranos** was a fitting name to encompass the entirety of our backend.

For extensive documentation and implementation, checkout our [```wiki```](https://github.com/UCLA-Creative-Labs/agora-ouranos/wiki).

[Implmentation Overview](#Implmentation-Overview)  
[Getting Started](#Getting-Started)  
&nbsp;&nbsp;&nbsp;&nbsp;[Local](#local)  
&nbsp;&nbsp;&nbsp;&nbsp;[Oracle Cloud Infrastructure](#Oracle-Cloud-Infrastructure)  

# Implementation Overview

At a glance, our backend is implemented as follows:

![architecture](/misc/architecture.png)

or if you are more interested in our cloud architecture:

![cloud](/misc/cloud.png)
[```WebSocket Protocol```](https://github.com/UCLA-Creative-Labs/agora-ouranos/wiki/Communication-Protocol-(WebSocket)) enables real-time event-driven communication between clients and servers. ```socket.io``` underpins the communication protocol throughout the entirety of ```Agora```.

[```Load Balancer```](https://github.com/UCLA-Creative-Labs/agora-ouranos/wiki/Horizontal-Scalability-(Load-Balancer)) **(Atlas)** allows us to coordinate distribution of clients to multiple ```node.js``` servers through an IP Hash Policy. Enabled with an SSL connection, our listener, **Hermes**, listens for socket connections and emissions from clients at ```https://atlas.creativelabsucla.com/```.

[```Application Servers```](https://github.com/UCLA-Creative-Labs/agora-ouranos/wiki/Application-Servers-(Node.js)) developed via ```node.js``` and ```express.js``` to provide server-side computation, optimization, and redirecting. We have 3 instances running (**Prometheus**, **Hyperion**, **Chronos**) each with 1+ app servers listening for client connections redirected by **Atlas**.

[```Redis```](https://github.com/UCLA-Creative-Labs/agora-ouranos/wiki/Horizontal-Scalability-(Redis)) utilized to allow our multiple app servers to communicate with each other as they get new strokes from the client. ```socket.io-redis``` provides really great utility for global communication between app servers through an integrated ```pub/sub`` protocol. 

[```PostgreSQL```](https://github.com/UCLA-Creative-Labs/agora-ouranos/wiki/Database-(PostgreSQL)) our **Achilles** heel and integral part of our backend. We used ```PostgreSQL``` because of its [ACID](https://retool.com/blog/whats-an-acid-compliant-database/) properties. We table our data through two columns: ```timestamp``` and ```JSON object```.

# Getting Started

Our backend is hoisted completely with [```Oracle Cloud Infrastructure```](https://www.oracle.com/cloud/). Through our process we weren't able to find the best documentation on how to implement our backend infrastructure. Hopefully, the following guide will be able to help you run ```Ouranos``` locally or on ```Oracle Cloud Infrastructure```.

We utilize a ```.env``` file for security reasons and recommend you follow the same protocol. 

```
Put the .env file in your root directory for your project

    cd agora-ouranos
    touch .env

Add the following to your .env file:

    DB_USER=<YOUR USERNAME HERE>        // by default our script, canvas_psql.sh, sets this to 'opc'
    DB_PWD=<YOUR PASSWORD HERE>
    DB_HOST=<PUBLIC IP OF DB HERE>      // if running locally then 127.0.0.1
    DB_NAME=canvas-db
    DB_PORT=5432                        // if unspecified postgres automatically ports to 5432

    REDIS_HOST=<PUBLIC IP HERE>         // if unbound, this is just the public IP or 127.0.0.1
    REDIS_PORT=6379                     // if unspecified redis automatically ports to 6379
    REDIS_PWD=<YOUR PASSWORD HERE>

```

## Local

We recommend using some sort of cloud infrastructure to view the full power of horizontal scalability. However, if you just want to get started the following guide might be a good place to start to understand sockets and postgres. 

** Note that in order to utilize ```Redis``` for multiple app servers, you will need a load balancer. See [below](#initialize-redis) for more details.

### Obtain the Repository and Install Dependencies
```
Clone the repository:

    git clone https://github.com/UCLA-Creative-Labs/agora-ouranos.git
    cd agora-ouranos


Dependencies:

    Node.js
    yarn
    PostgreSQL
    Redis*

Install Dependencies:

    # Downloads NVM (for node.js)
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

    # Downloads YARN
    curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
    sudo rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg

    # Sourcing the bash intializing script to export nvm to $PATH	
    source ~/.bashrc	

    # Switch to the correct node version	
    # Run node --version or npm --version to ensure its not 8.1	
    nvm install node	

    # Installs to node modules 	
    # express   => node.js framework	
    # postgres  => easily interface with postgres server	
    # nodemon   => watch changes to your node.js applications and update them
    # socket.io => connecting to client
    yarn install
    
* Only necessary if you want to run multiple node.js applciations
```

### Initialize Database

We have a script to initialize a postgres server very quickly.

```
Intialize postgres database:

    bash canvas_psql.sh

Breakdown:
    - init postgres
    - start postgres
    - create a user (call it 'opc' or whatever you want to use in .env file)
    - set password for user (user currently is defaulted to ```opc``` but change it in the canvas_psql file to match .env)
    - create a database (call it canvas-db)
    - create a table called canvas_data
```

### Initialize Redis

Only complete this step if you want to use **multiple nodes** and have a method for **load balancing**!!!

To load balance locally, follow this [guide](https://blog.jscrambler.com/scaling-node-js-socket-server-with-nginx-and-redis/).

```
Install Redis:

    sudo yum install redis -y               // yum is for CentOS and RHEL operating systems
    sudo systemctl start redis.service
    sudo systemctl enable redis

    sudo systemctl status redis.service     // check the status for you redis service
    redis-cli ping                          // you should get the output 'PONG'

```

### Usage

Time to get our app server working.

The following documentation is to show you how to start up a server and prove that it works.

```
Start your node.js development server:

    yarn start

Check out your localhost to see if app server is listening at port 3000:

    http://127.0.0.1:3000/

You should see something like this:

    Cannot /GET

Since we are using sockets, it makes sense that there is no '/GET' at the base of localhost:3000.
```

Congrats, you just spun up ```Ouranos``` locally!

## Oracle Cloud Infrastructure

The following guide is to get you started with deploying a single app server instance. For a more indepth walkthrough on how to use [```Oracle Cloud Infrastructure```](https://www.oracle.com/cloud/) to create a horizontally scaled application, take a look at our [```wiki```](https://github.com/UCLA-Creative-Labs/agora-ouranos/wiki).

Unfortunately, OCI instances come with empty images that have no installed tools in it. OCI base images are essentially CentOS and use RPM to download modules. Whenever you need to download things always use the command ```sudo yum install -y <name of package>```.

### Installing Git and Obtaining this Repository

```
Install git:

    sudo yum install -y git

Clone the repository:

    git clone https://github.com/UCLA-Creative-Labs/node-psql-rest.git

```

### Installing Dependencies and Requirements

We have a script to download all the stuff you need.

You will need to go to your ingress rules for your Pulbic Subnet and allow inbound communication through ports ```3000```, ```5432```, and ```6379```.

#### Run

```
Install Dependencies, nvm, and open the firewall for port 3000:

    bash start.sh

    # Sourcing the bash intializing script to export nvm to $PATH	
    source ~/.bashrc	

    # Switch to the correct node version	
    # Run node --version or npm --version to ensure its not 8.1	
    nvm install node	

    # Installs to node modules 	
    # express   => node.js framework	
    # postgres  => easily interface with postgres server	
    # nodemon   => watch changes to your node.js applications and update them
    # socket.io => connecting to client
    yarn install

If postgres is also on this instance, then run the following. 

    sudo firewall-cmd --add-port=5432/tcp
    sudo firewall-cmd --permanent --add-port=5432/tcp
```

#### Breakdown

- update yum
- download nvm (node version manager)
    - use this to switch between node versions
    - run ```nvm install <node version number>``` for a specific version
    - run ```nvm use <node version number>``` to switch node version
    - run ```node --version``` to check
- download yarn
- install requirements 
- install node dependencies
- allow port access to 3000

Extensive documenation in ```start.sh```.

### Initializing Postgres Database 

We have a script to initialize a postgres server very quickly.

#### Run

```
Initialize postgres database:

    bash canvas_psql.sh
```

#### Breakdown

- init postgres
- start postgres
- create a user (call it 'opc' or whatever you want to use in ```queries.js```)
- create a database (call it 'api' or whatever you want to use in ```queries.js```)
- set password for user (user currently is defaulted to ```opc``` with a default password of ```test``` in ```queries.js```)
- create a table called ```users``` 
- populate ```users``` table with our bois Jerry and George

Extensive documenation in ```psql.sh```.

### Changing Postgres Authentication Method

Default authentication method is ```ident``` which requires an ident server to authenticate the user. Instead we switch to ```md5``` which is simply a hashed password authentication.

#### Run the following code

```
First enter root user to access pqsl configuration file:

    sudo -i
    cd /var/lib/pgsql/data/
    vim pg_hba.conf

Replace the following with this:

    # TYPE  DATABASE        USER            ADDRESS                 METHOD

    # "local" is for Unix domain socket connections only
    #local  all             all                                     peer
    host    all             all                                     md5
    # IPv4 local connections:
    #host   all             all             127.0.0.1/32            ident
    host    all             all             127.0.0.1/32            md5
    # IPv6 local connections:
    #host   all             all             ::1/128                 ident
    host    all             all             ::1/128                 md5

Finally run this outside of root user:

    psql -d <database_name> -c "SELECT pg_reload_conf();"

If you edit the postgres.conf file then run this:

    sudo systemctl restart postgresql

```

### Usage

Time to get our app server working.

The following documentation is to show you how to start up a server and prove that it works.

```
Start your node.js development server:

    yarn start

Check out the public IP address of your VM instance to see if app server is listening at port 3000:

    http://pub.lic.ip.add:3000/

You should see something like this:

    Cannot /GET

Since we are using sockets, it makes sense that there is no '/GET' at the base of http://pub.lic.ip.add:3000/.
```

Congrats, you just spun up ```Ouranos``` on the cloud!