FROM node:18-alpine as build

WORKDIR /app

COPY . .
RUN yarn install --immutable
ENV NODE_ENV=production
RUN yarn run webclient:build

FROM alpine:3.17 as final

RUN apk --no-cache add --upgrade nodejs~18

RUN mkdir -p /app
WORKDIR /app

COPY --from=build /app/node_modules node_modules
COPY package.json package.json
COPY --from=build /app/dist dist
COPY favicon.ico favicon.ico
COPY lib lib

ENV NODE_ENV=production
CMD /bin/sh -c "node ./dist/proxy.js"
