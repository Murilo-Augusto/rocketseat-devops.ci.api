FROM node:24 AS build

RUN npm install -g pnpm@latest

WORKDIR /usr/src/app

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

RUN pnpm install --frozen-lockfile

COPY . .

RUN pnpm run build
RUN pnpm prune --prod

FROM node:24-alpine

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./dist/node_modules

EXPOSE 3000

CMD [ "npm", "run", "start:prod" ]