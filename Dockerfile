FROM handersonsilva/k3s-php:local

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

# Copiando scripts e config necessários para dentro da imagem.
COPY ./docker/php/docker-start.sh /docker/docker-start.sh
COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/custom.ini

# Copia o diretório da aplicação para o container
COPY ./src /var/www/html

WORKDIR /var/www/html

# Altera permissão de execução para o script entrypoint
RUN chmod +x /docker/docker-start.sh \
    # Cria grupo, usuário e o atribui ao grupo
   && useradd -u ${USER_ID} -g www-data --shell /bin/bash --create-home switch

EXPOSE 80 9000 3000 4173

# Script de inicialização do container
ENTRYPOINT ["/docker/docker-start.sh"]