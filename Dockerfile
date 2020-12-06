FROM node:current-alpine AS base
WORKDIR /base
COPY package*.json ./
RUN npm install && npm cache clean --force
COPY . .

FROM base AS build
ENV NODE_ENV=production
WORKDIR /build
COPY --from=base /base ./
RUN npm run build

FROM node:current-alpine AS production
ENV NODE_ENV=production
WORKDIR /app
COPY --from=build /build/package*.json ./
RUN npm i --only=production && npm cache clean --force
COPY --from=build /build ./

ENV PORT=8080
EXPOSE 8080
CMD npm run start:prod