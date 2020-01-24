#!/bin/sh -l

echo "Hello $1"
time=$(date)

node ./index.js

echo ::set-output name=time::$time