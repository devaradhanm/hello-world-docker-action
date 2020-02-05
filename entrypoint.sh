#!/bin/sh -l

time=$(date)

echo "files under /github/workspace/$1"
ls /github/workspace/$1

echo "Starting http server..."
http-server /github/workspace/$1 -p 9123 &

echo "Starting Scan..."
ai-scan --url http://127.0.0.1:9123 --output /github/workspace/$2

echo "Scan completed!"
echo ::set-output name=time::$time
