# Agora - Ouranos (Backend Implementation)

In ancient Greek, the word **```agora```** means a public open space for gathering. In a day in age where COVID-19 has prohibited physical gatherings, we, at Creative Labs, have created a platform for individuals to gather around: **```Agora```**. **```Agora```** is a collaborative canvas centered around community. We built it so that every individual can only contribute one stroke at a time with the hope that people would come together to build something amazing. 

This repository is dedicated to the backend architecture of **```Agora```** which we dubbed after the sky titan **Ouranos**. Much like how the sky is an integral part of our lives that we all take for granted, our backend models a similar ideology. As the father of titans and the husband of Gaia (frontend), **Ouranos** was a fitting name to encompass the entirety of our backend.

For extensive ***documentation*** and ***implementation***, checkout our [```wiki```](https://github.com/UCLA-Creative-Labs/agora-ouranos/wiki).

To see how to deploy on [```Oracle Cloud Infrastructure```](https://www.oracle.com/cloud/), checkout this [```wiki page```](https://github.com/UCLA-Creative-Labs/agora-ouranos/wiki/Deploying-to-Oracle-Cloud-Infrastructure)


# Getting Started - Locally

Our backend is hoisted completely with [```Oracle Cloud Infrastructure```](https://www.oracle.com/cloud/). Through our process we weren't able to find the best documentation on how to implement our backend infrastructure. Hopefully, the following guide will be able to help you run ```Ouranos``` locally.

We recommend using some sort of cloud infrastructure to view the full power of horizontal scalability. However, if you just want to get started the following guide might be a good place to start to understand sockets and postgres. 

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

** Note that in order to utilize ```Redis``` for multiple app servers, you will need a load balancer. See [below](#initialize-redis) for more details.

## Obtain the Repository and Install Dependencies
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

## Initialize Database

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

## Initialize Redis

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

## Usage

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