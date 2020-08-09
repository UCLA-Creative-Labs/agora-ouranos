#!/bin/bash

function cli(){
  source ~/agora-ouranos/scripts/cli.sh
}

function dbsize(){
  psql canvas-db -c "SELECT count(*) FROM canvas_data;"
  psql canvas-db -c "SELECT pg_size_pretty(pg_table_size('canvas_data'));"
}

function destroy(){
  kill -9 $(lsof -t -i:8080)
  kill -9 $(lsof -t -i:3000)
  pkill node
}

function deploy(){
  curr_dir=$(pwd)
  cd ~/agora-ouranos
  nohup node index.js > ~/ouranos.log 2> ~/ouranos.err &
  cd $curr_dir
}

function clear(){
  echo '' > ~/ouranos.log
  echo '' > ~/ouranos.err
}