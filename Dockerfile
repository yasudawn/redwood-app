# ==
# Base
FROM node:16 as base

ARG NODE_ENV
ARG RUNTIME_ENV
ENV NODE_ENV=$NODE_ENV
ENV RUNTIME_ENV=$RUNTIME_ENV

WORKDIR /app

COPY web web
COPY .nvmrc .
COPY graphql.config.js .
COPY package.json .
COPY docker.toml ./redwood.toml
COPY yarn.lock .

COPY api/package.json api/package.json
COPY web/package.json web/package.json

RUN yarn install

# ==
# Build
FROM base as build

COPY api api
COPY web web

RUN yarn rw build web
RUN yarn rw build api

# ==
# Serve
FROM node:16 as serve

WORKDIR /app

COPY --from=build /app/node_modules/.prisma /app/api/node_modules/.prisma
COPY --from=build /app/api/dist /app/api/dist
COPY --from=build /app/api/package.json /app/api/package.json
COPY --from=build /app/yarn.lock /app/api/yarn.lock

COPY --from=build /app/web/dist /app/web/dist

COPY --from=build /app/redwood.toml /app/redwood.toml

RUN yarn --cwd "api" --production --frozen-lockfile install && \
  yarn global add @redwoodjs/cli react react-dom

EXPOSE 8910

ENTRYPOINT [ "rw", "serve" ]
CMD []

