#!/bin/bash

# Let's postgres run commands
sudo chmod og+rX /home /home/opc

# init postgres
sudo postgresql-setup initdb

# start postgres
sudo systemctl start postgresql

# enable postgres
sudo systemctl enable postgresql

# create a user: recommend to call it 'opc' with pw 'test' because queries.js uses 'opc'as user
sudo -u postgres createuser --interactive -P

# create a database called 'api': recommended becasue querires.js uses 'api' as database
sudo -u postgres createdb canvas-db
 
###################################################
#    Bash Shell script to execute psql command    # 
###################################################
 
#Set the value of variable
database="canvas-db"
username="opc"
 
#Execute few psql commands: 
#Note: you can also add -h hostname -U username in the below commands.

psql -d $database -h localhost -U $username -c "CREATE TABLE canvas-data (time_stamp TIMESTAMPTZ, data JSON);"
