FROM node:20-slim

RUN npm install -g npm@latest
RUN npm install -g code-server --unsafe-perm --ignore-scripts --no-audit --prefer-offline
