#!/bin/sh -l

echo "Hello $1"
time=$(date)

echo "Starting http server..."
http-server /workspace/_site -p 9123 &

echo "Starting Scan..."
ai-scan --url http://127.0.0.1:9123 --output /workspace/_report

echo "Scan completed!"
echo ::set-output name=time::$time
