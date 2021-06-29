# Base
FROM node:12-alpine AS base

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build && npm prune --production

# Application
FROM node:lts-slim as application

COPY --from=base package*.json ./
COPY --from=base /node_modules ./node_modules
COPY --from=base /dist ./dist

EXPOSE 4000
CMD ["npm", "run", "start:prod"]
