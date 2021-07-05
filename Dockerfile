# Build
FROM node:12-alpine AS build
WORKDIR /usr/src/app

COPY package*.json ./
COPY tsconfig.json tsconfig.build.json ./
COPY src/ ./src/
RUN npm install && npm run build

# Dependencies
FROM node:12-alpine AS deps
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci && npm prune --production

# Application
FROM node:12-alpine
WORKDIR /usr/src/app

COPY --from=build usr/src/app/package*.json ./
COPY --from=build usr/src/app/dist ./dist
COPY --from=deps usr/src/app/node_modules ./node_modules

EXPOSE 4000
CMD ["npm", "run", "start:prod"]
