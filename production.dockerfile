FROM handersonsilva/k3s-php:production

# Install calendar extension
RUN docker-php-ext-install calendar \
    && docker-php-ext-enable calendar

# Install gd extension with WebP support
RUN apt-get update && apt-get install -y libwebp-dev libjpeg-dev libpng-dev \
    && docker-php-ext-configure gd --with-webp --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-enable gd

# Id do usuário
ARG USER_ID=1000

#supervisor
COPY ./docker/php/supervisord.conf /etc/supervisor
COPY ./docker/config/* /etc/supervisor/conf.d

# Copiando scripts e config necessários para dentro da imagem.
COPY ./docker/php/docker-start-production.sh /docker/docker-start-production.sh
COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/php.ini
COPY ./docker/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Copia o diretório da aplicação para o container
COPY ./src /var/www/html

WORKDIR /var/www/html

RUN composer install --no-scripts

RUN chmod -R 777 /var/www/html/storage
RUN chmod -R 777 /var/www/html/bootstrap
RUN chmod -R 777 /var/log/supervisor

# Altera permissão de execução para o script entrypoint
RUN chmod +x /docker/docker-start-production.sh \
        # Cria grupo, usuário e o atribui ao grupo
       && useradd -u ${USER_ID} -g www-data --shell /bin/bash --create-home switch

# Define o usuário
USER switch

# Inicia o Supervisor
RUN mkdir /home/switch/supervisor

EXPOSE 9000

# Script de inicialização do container
ENTRYPOINT ["/docker/docker-start-production.sh"]
