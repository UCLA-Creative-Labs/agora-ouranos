# Agora - Ouranos (Backend Implementation)

In ancient Greek, the word ```agora``` means a public open space for gathering. In a day in age where COVID-19 has prohibited physical gatherings, we, at Creative Labs, have created a platform for individuals to gather around: ```Agora```. ```Agora``` is a collaborative canvas centered around community. We built it so that every individual can only contribute one stroke at a time with the hope that people would come together to build something amazing. 

This repository is dedicated to the backend architecture of ```Agora``` which we dubbed after the sky titan **Ouranos**. Much like how the sky is an integral part of our lives that we all take for granted, our backend models a similar ideology. As the father of titans and the husband of Gaia (frontend), **Ouranos** was a fitting name to encompass the entirety of our backend.

# Overview

At a glance, our backend is implemented as follows:

![architecture](/misc/architecture.png)

or if you are more interested in our cloud architecture:

![cloud](/misc/cloud.png)

```WebSocket Protocol``` enables real-time event-driven communication between clients and servers. ```socket.io``` underpins the communication protocol throughout the entirety of ```Agora```.

```Load Balancer``` **(Atlas)** allows us to coordinate distribution of clients to multiple ```node.js``` servers through an IP Hash Policy. Enabled with an SSL connection, our listener, **Hermes**, listens for socket connections and emissions from clients at ```https://atlas.creativelabsucla.com/```.

```Application Servers``` developed via ```node.js``` and ```express.js``` to provide server-side computation, optimization, and redirecting. We have 3 instances running (**Prometheus**, **Hyperion**, **Chronos**) each with 1+ app servers listening for client connections redirected by **Atlas**.

```Redis``` utilized to allow our multiple app servers to communicate with each other as they get new strokes from the client. ```socket.io-redis``` provides really great utility for global communication between app servers through an integrated ```pub/sub`` protocol. 

```PostgreSQL``` our **Achilles** heel and integral part of our backend. We used ```PostgreSQL``` because of its [ACID](https://retool.com/blog/whats-an-acid-compliant-database/) properties. We table our data through two columns: ```timestamp``` and ```JSON object```.

# Architecture

We developed our backend with scalability in mind. We quickly came to the conclusion that a singular ```Node.js``` application server connected to a ```PostgreSQL``` database would not be sufficient to combat user load. Thus, we turned towards creating a more distributed system to handle greater amounts of user connections.

## Communication Protocol (WebSocket)

```Agora 0.5``` originally had a RESTful API implementation. We decided to pivot towards a WebSocket implementation to achieve real-time collaboration with other users. We used [```socket.io```](https://socket.io/docs/) as our library for client-to-server and server-to-client connections. Using web sockets, we are able to utilize a bidirectional, event-driven, real-time communication protocol between clients and server nodes for better functionality. 

### Implementation

```
    Blah
```

## Application Servers (Node.js + Express.js)

### Implmentation

```
    Blah
```

## Database (PostgreSQL)

### Implementation

```
    Blah
```

## Horizontal Scalability

### Implementation

```
    Blah
```
