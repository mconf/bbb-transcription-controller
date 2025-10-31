FROM node:22-slim AS builder

ENV NODE_ENV=production

WORKDIR /app

RUN apt-get update \
 && apt-get -y install build-essential python3

COPY package.json package-lock.json /app/

RUN npm ci --omit=dev \
 && npm cache clear --force

FROM node:22-slim

ENV NODE_ENV=production

COPY --from=builder /app /app

WORKDIR /app

COPY . .

RUN cp config/default.example.yml config/production.yml

CMD [ "npm", "start" ]

