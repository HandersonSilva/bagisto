FROM nginx:latest

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs

COPY ./docker/web/nginx.conf /etc/nginx/conf.d/default.conf

COPY ./src /var/www/html

WORKDIR /var/www/html

#install node dependencies
#RUN npm install && npm run build