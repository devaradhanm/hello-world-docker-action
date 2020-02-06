#!/bin/sh -l

time=$(date)

echo "who am i?"
whoami

echo "files under /github/workspace/$1"
ls /github/workspace/$1


echo "Starting http server..."
npx http-server /github/workspace/$1 -p 9123 &

echo "Starting Scan..."
node /node_modules/accessibility-insights-scan/dist/ai-scan.js --url http://127.0.0.1:9123 --output /github/workspace/$2

echo "Scan completed!"
echo ::set-output name=time::$time
