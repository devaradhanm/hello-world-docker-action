#!/bin/sh -l

echo "Hello $1"
time=$(date)

echo "files under /github/workspace"
ls /github/workspace

echo "files under /workspace/_site"
ls /workspace/_site

echo "Starting http server..."
http-server /workspace/_site -p 9123 &

echo "Starting Scan..."
ai-scan --url http://127.0.0.1:9123 --output /workspace/_report

echo "Scan completed!"
echo ::set-output name=time::$time
