# Container image that runs your code
FROM cypress/base:12.13.0

RUN npm install -g http-server
RUN npm install -g accessibility-insights-scan

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN echo "building docker image"

# Add user so we don't need --no-sandbox.	
# same layer as npm install to keep re-chowned files from using up several hundred MBs more space	
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \	
    && mkdir -p /home/pptruser/Downloads \	
    && chown -R pptruser:pptruser /usr/local/lib/node_modules \
    && chown -R pptruser:pptruser /home/pptruser	

RUN sysctl -w kernel.unprivileged_userns_clone=1

# Run everything after as non-privileged user.	
USER pptruser

ENTRYPOINT ["/bin/sh", "-c", "xvfb-run --server-args=\"-screen 0 1024x768x24\" /entrypoint.sh", ""]
