FROM node:lts-alpine as build-stage

LABEL maintainer="Hoppscotch (support@hoppscotch.io)"

# Add git as the prebuild target requires it to parse version information
RUN apk add --no-cache --virtual .gyp \
  python3 \
  make \
  g++

# Create app directory
WORKDIR /app

ADD . /app/

COPY . .

RUN npm install -g pnpm

RUN pnpm i --unsafe-perm=true

ENV HOST 0.0.0.0
EXPOSE 3000

RUN mv packages/hoppscotch-app/.env.example packages/hoppscotch-app/.env

RUN pnpm run generate



FROM 3444866/nginx:0.0.7

COPY --from=build-stage /app/packages/hoppscotch-app/dist /usr/share/nginx/html
