const express = require("express");
const http = require("http");
const socketIo = require("socket.io");
const db = require('./queries.js');

const args = process.argv.slice(2);
const NAME = args[0];
const PORT = args[1];
require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: [ 'http://localhost:8080', /.*\.creativelabsucla\.com$/],
    methods: [ 'GET', 'POST' ],
    credentials: true,
  },
});
var redis = require('socket.io-redis');
io.adapter(redis({host: process.env.REDIS_HOST, port: process.env.REDIS_PORT, auth_pass: process.env.REDIS_PWD}))

var client_count = 0;
let client_pool = new Map();

var buffer_time_sec = 10;
var buffer_time     = buffer_time_sec * 1000; 

var draw_limit_sec  = 20;
var draw_limit      = draw_limit_sec * 1000;

const send_handshake = (socket) =>{
  client_pool.set(socket.handshake.address, {'last_send': Date.now(), 'can_undo': true});
  socket.emit('handshake', client_pool.get(socket.handshake.address))
};

let dev_reset = true;

io.on("connection", (socket) => {
  if(dev_reset)                     // FOR DEV RESETS ONLY
    socket.emit('reset', null);

  socket.emit('limit', draw_limit);

  if(!client_pool.get(socket.handshake.address)){      // If current IP address has NOT been seen before
    client_pool.set(socket.handshake.address, {'last_send': null, 'can_undo': false});
  }
  socket.emit('handshake', client_pool.get(socket.handshake.address))
  client_count += 1;
  console.log(`${new Date()}: New connection, count: ${client_count}`);

  socket.on('init', (timestamp) => {
      db.getData(socket, timestamp);
  });

  socket.on("update", (data) => {
    send_handshake(socket)
    db.queueData(client_pool, buffer_time, data, socket);
  });

  socket.on("undo", (data) => {
    let erased;

    if(client_pool.get(socket.handshake.address).can_undo){
      client_pool.get(socket.handshake.address).can_undo = false;
      erased = true;
    }else{
      erased = false;
    }

    socket.emit('erase', erased);
  });

  socket.on("disconnect", () => {
    client_count -= 1;
    console.log(`${new Date()}: Client disconnected, count: ${client_count}`);
  });
});

server.listen(PORT, () => console.log(`${NAME} => Listening on port ${PORT}`));

