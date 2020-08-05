#!/bin/bash

psql canvas-db -c "SELECT count(*) FROM canvas_data;"
psql canvas-db -c "SELECT pg_size_pretty(pg_table_size('canvas_data'));"