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
  NAME=$1
  PORT=$2
  cd ~/agora-ouranos
  nohup node index.js $NAME $PORT > logs/$NAME.log 2> logs/$NAME.err &
  cd $curr_dir
}

function clear(){
  echo '' > ~/ouranos.log
  echo '' > ~/ouranos.err
}