# ---- 1) Base n8n image ------------------------------------------------
FROM n8nio/n8n:1.51.1             # pin a stable tag

# ---- 2) Switch to root for package installs --------------------------
USER root

# Install OS packages: ffmpeg (audio), chromium (browser), curl (to fetch yt-dlp)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        chromium \
        ca-certificates \
        curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download the latest yt-dlp binary and make it executable
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
     -o /usr/local/bin/yt-dlp && \
    chmod a+rx /usr/local/bin/yt-dlp

# ---- 3) Install global Node deps --------------------------------------
RUN npm install -g \
      n8n-nodes-youtube-audio@latest \
      puppeteer-extra \
      puppeteer-extra-plugin-stealth

# Tell Puppeteer where Chromium lives
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# ---- 4) Copy your patch directory into the image ----------------------
COPY patch /data/patch

# ---- 5) Run the patch script to inject custom browser loader ----------
RUN chmod +x /data/patch/overwrite.sh && \
    /bin/bash /data/patch/overwrite.sh

# ---- 6) Drop back to the default n8n user ----------------------------
USER node
