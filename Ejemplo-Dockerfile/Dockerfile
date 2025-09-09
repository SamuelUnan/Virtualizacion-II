FROM postgres:15.5

ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=admin123
ENV POSTGRES_DB=defaultdb

COPY init.sql /docker-entrypoint-initdb.d/

COPY custom-postgres.conf /etc/postgresql/custom.conf

RUN apt-get update && apt-get install -y \
    postgresql-contrib \
    vim less \
    && rm -rf /var/lib/apt/lists/*

VOLUME ["/var/lib/postgresql/data"]

EXPOSE 5432

CMD ["postgres", "-c", "config_file=/etc/postgresql/custom.conf"]