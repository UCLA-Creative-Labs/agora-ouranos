#!/bin/bash

kill -9 $(lsof -t -i:8080)
kill -9 $(lsof -t -i:3000)

pkill node