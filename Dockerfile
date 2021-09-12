FROM node:12 AS build
WORKDIR /app/react-app
COPY package* yarn.lock ./
COPY public ./public
COPY src ./src
RUN yarn install && yarn run build

FROM nginx
RUN touch /var/run/nginx.pid && chgrp -R 0 /var/run/nginx.pid && chmod -R g=u /var/run/nginx.pid && chgrp -R 0 /var/cache/nginx && chmod -R g=u /var/cache/nginx  && sed -i 's#listen  [::]:80#listen  [::]:8080#g' /etc/nginx/conf.d/default.conf
EXPOSE 8080
COPY --from=build /app/react-app/build /usr/share/nginx/html
