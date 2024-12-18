FROM node:18
WORKDIR /usr/code
COPY package*.json ./

# Chromium fix for ARM (like Apple M1) 
RUN if [ "$(uname -m)" = "aarch64" ] ; then \
    apt-get update \
    && apt-get install -y \
        chromium \
        fonts-ipafont-gothic \
        fonts-wqy-zenhei \
        fonts-thai-tlwg \
        fonts-kacst \
        fonts-freefont-ttf \
        libxss1 \
        --no-install-recommends ; \
    apt-get update && apt-get install -y chromium ; \
    export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true ; \
    export PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser ; \
    npm install -g html-pdf-node ; \
fi

RUN npm install

RUN npm install nodemon -g
COPY . .
RUN npm run build
EXPOSE 9000
CMD ["node", "server.js"]
