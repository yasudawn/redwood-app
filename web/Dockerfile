###########################################################################################
# Builder: node
###########################################################################################

FROM node:16 as builder

# Node
ARG NODE_ENV
ARG RUNTIME_ENV
ENV NODE_ENV=$NODE_ENV
ENV RUNTIME_ENV=$RUNTIME_ENV

# Set workdir
WORKDIR /app

COPY web web
COPY .nvmrc .
COPY graphql.config.js .
COPY package.json .
COPY docker.toml ./redwood.toml
COPY yarn.lock .

# Install dependencies
RUN yarn install

# Build
RUN yarn rw build web

# Clean up
RUN rm -rf ./web/src

###########################################################################################
# Runner: Nginx
###########################################################################################

FROM nginx:alpine as runner

# Copy dist
COPY --from=builder /app/web/dist /usr/share/nginx/html

# Copy nginx configuration
COPY /web/config/nginx.conf /etc/nginx/conf.d/default.conf

# List files
RUN ls -lA /usr/share/nginx/html

# Expose RedwoodJS web port
EXPOSE 8910
