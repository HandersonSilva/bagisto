FROM handersonsilva/k3s-php:local

# Install xdebug
#RUN pecl install xdebug
#RUN docker-php-ext-enable xdebug

# Install OPCache
#RUN docker-php-ext-install opcache && pecl install pcov && docker-php-ext-enable pcov;

RUN apt-get update && apt-get install -y libexif-dev \
    libicu-dev \
    && docker-php-ext-install exif \
    && docker-php-ext-enable exif \
    && docker-php-ext-install intl \
    && docker-php-ext-enable intl

# Install gd extension with WebP support
RUN apt-get update && apt-get install -y libwebp-dev libjpeg-dev libpng-dev \
    && docker-php-ext-configure gd --with-webp --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-enable gd

# Install extensions Decimal
RUN apt install -y libmpdec-dev
RUN pecl install decimal

# Install calendar extension
RUN docker-php-ext-install calendar \
    && docker-php-ext-enable calendar

RUN docker-php-ext-install pdo_mysql

# Id do usuário
ARG USER_ID=1000

# Copiando scripts e config necessários para dentro da imagem.
COPY ./docker/php/docker-start.sh /docker/docker-start.sh
COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/custom.ini

# Copia o diretório da aplicação para o container
COPY ./src /var/www/html

WORKDIR /var/www/html

RUN rm -rf /var/www/html/composer.lock
#RUN composer install
# Install node
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs

#install node dependencies
#RUN npm install && npm run build

#RUN chmod -R 777 /var/www/html/storage

# Altera permissão de execução para o script entrypoint
RUN chmod +x /docker/docker-start.sh \
    # Cria grupo, usuário e o atribui ao grupo
   && useradd -u ${USER_ID} -g www-data --shell /bin/bash --create-home switch

EXPOSE 80 9000 3000 4173

# Script de inicialização do container
ENTRYPOINT ["/docker/docker-start.sh"]