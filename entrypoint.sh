#!/bin/sh -l

echo "granting permissions to pptuser"
chown -R pptruser:pptruser /github
echo "changing user..."
su -l pptruser

time=$(date)
#ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

echo "who am i?"
whoami

echo "files under /github/workspace/$1"
ls /github/workspace/$1


#echo "Starting http server..."
#npx http-server /github/workspace/$1 -p 9123 &

echo "Starting Scan for bing..."
#node /node_modules/accessibility-insights-scan/dist/ai-scan.js --url http://127.0.0.1:9123 --output /github/workspace/$2
node /node_modules/accessibility-insights-scan/dist/ai-scan.js --url https://www.bing.com --output /github/workspace/$2

echo "Scan completed!"
echo ::set-output name=time::$time
