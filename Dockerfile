# ---- 1) Base image -------------------------------------------------
FROM n8nio/n8n:1.51.1             # pin a stable tag

# ---- 2) Become root to install OS packages ------------------------
USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg chromium && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ---- 3) Install global Node deps ----------------------------------
RUN npm install -g \
      n8n-nodes-youtube-audio@latest \
      puppeteer-extra \
      puppeteer-extra-plugin-stealth

# Puppeteer must know where Chromium is:
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# ---- 4) Copy our patch directory ----------------------------------
COPY patch /data/patch

# ---- 5) Run script that overwrites browser helper -----------------
RUN /bin/bash /data/patch/overwrite.sh

# ---- 6) Drop back to node user ------------------------------------
USER node
