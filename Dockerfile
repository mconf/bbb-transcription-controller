#
# To build: docker build -t bigbluebutton/transcription-controller .
# To run (with config file): docker run -d --name bbb-transcription-controller --restart always -v $(pwd)/default.yml:/app/config/default.yml docker.io/mconf/bbb-transcription-controller:latest
# To run (with environment variables): docker run -d --name bbb-transcription-controller --restart always -e GLADIA_KEY="your-key" -e REDIS_HOST="redis" -e FREESWITCH_PASSWORD="password" docker.io/mconf/bbb-transcription-controller:latest

FROM node:22-slim AS builder

ENV NODE_ENV=production

WORKDIR /app

RUN apt-get update \
 && apt-get -y install build-essential python3

COPY package.json package-lock.json /app/

RUN npm ci \
 && npm cache clear --force

FROM node:22-slim

ENV NODE_ENV=production

COPY --from=builder /app /app

WORKDIR /app

COPY . .

RUN cp config/default.example.yml config/default.yml

CMD [ "npm", "start" ]

