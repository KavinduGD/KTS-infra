FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm install --production


COPY scripts ./scripts
COPY server.js .

# make scripts executable
RUN chmod +x /app/scripts/*

RUN apk add --no-cache \
    docker-cli \
    docker-compose \
    bash

EXPOSE 3000

CMD ["node", "server.js"]
