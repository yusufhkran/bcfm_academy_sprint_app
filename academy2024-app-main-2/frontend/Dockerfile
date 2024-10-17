FROM node:latest AS build

WORKDIR /app

COPY . .

RUN npm install --legacy-peer-deps 

RUN npm run build

FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]