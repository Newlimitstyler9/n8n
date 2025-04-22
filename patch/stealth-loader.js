/**
 * Custom browser launcher for n8n‑nodes‑youtube‑audio
 * – Adds puppeteer‑extra + stealth plugin
 * – Supports residential proxy via env‑var PROXY_SERVER
 * – Persists cookies in CHROME_USER_DATA_DIR
 */

const puppeteer     = require('puppeteer-extra');
const StealthPlugin = require('puppeteer-extra-plugin-stealth');

puppeteer.use(StealthPlugin());

module.exports.getBrowser = async () => {
  return puppeteer.launch({
    headless: false,                                       // head‑FUL avoids easy detection
    executablePath: process.env.PUPPETEER_EXECUTABLE_PATH, // set in Dockerfile
    userDataDir: process.env.CHROME_USER_DATA_DIR || '/tmp/chrome',
    args: [
      `--proxy-server=${process.env.PROXY_SERVER || ''}`,  // empty string = no proxy
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
    ],
    defaultViewport: { width: 1280, height: 720 },
  });
};
