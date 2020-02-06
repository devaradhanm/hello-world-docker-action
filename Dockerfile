# Container image that runs your code
FROM node:13.7-slim

RUN echo "building docker image"

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get install -y wget gnupg2 ca-certificates --no-install-recommends
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update
RUN apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf --no-install-recommends 
RUN rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64.deb
RUN dpkg -i dumb-init_*.deb

#for xvfb-run dependencies
RUN apt-get update && \
    apt-get -y install xvfb xauth --no-install-recommends

# Add user so we don't need --no-sandbox.
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser

RUN npm install http-server
RUN npm install accessibility-insights-scan

RUN chown -R pptruser:pptruser /node_modules

# Run everything after as non-privileged user.
USER pptruser

RUN echo "who am i?"
RUN whoami

ENTRYPOINT ["dumb-init", "--"]
CMD ["/bin/sh", "-c", "xvfb-run --server-args=\"-screen 0 1024x768x24\" /entrypoint.sh"]
