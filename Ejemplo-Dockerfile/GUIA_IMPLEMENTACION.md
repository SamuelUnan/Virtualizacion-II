# Guía Práctica: Implementación de PostgreSQL con Docker

## Requisitos Previos
- Docker instalado en tu sistema
- Acceso a línea de comandos (PowerShell, CMD, o terminal)
- Editor de texto para modificar archivos si es necesario

## Estructura del Proyecto
```
.
├── Dockerfile          # Configuración del contenedor PostgreSQL
├── custom-postgres.conf # Configuración personalizada de PostgreSQL
└── init.sql           # Script de inicialización de la base de datos
```

## Creación y Composición del Dockerfile

### Estructura del Dockerfile
```dockerfile
# Usar la imagen oficial de PostgreSQL 15.5
FROM postgres:15.5

# Configuración de variables de entorno
ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=admin123
ENV POSTGRES_DB=defaultdb

# Copiar el script de inicialización
COPY init.sql /docker-entrypoint-initdb.d/

# Copiar configuración personalizada de PostgreSQL
COPY custom-postgres.conf /etc/postgresql/custom.conf

# Instalar paquetes adicionales
RUN apt-get update && apt-get install -y \
    postgresql-contrib \
    vim less \
    && rm -rf /var/lib/apt/lists/*

# Definir volumen para persistencia de datos
VOLUME ["/var/lib/postgresql/data"]

# Exponer el puerto estándar de PostgreSQL
EXPOSE 5432

# Iniciar PostgreSQL con la configuración personalizada
CMD ["postgres", "-c", "config_file=/etc/postgresql/custom.conf"]
```

### Explicación de las secciones del Dockerfile

1. **FROM**: 
   - Especifica la imagen base (PostgreSQL 15.5)
   
2. **ENV**: 
   - Establece variables de entorno para la configuración de PostgreSQL
   - `POSTGRES_USER`: Usuario administrador
   - `POSTGRES_PASSWORD`: Contraseña del usuario
   - `POSTGRES_DB`: Nombre de la base de datos por defecto

3. **COPY**:
   - Copia el script `init.sql` al directorio de inicialización de PostgreSQL
   - Copia el archivo de configuración personalizado

4. **RUN**:
   - Actualiza los repositorios de paquetes
   - Instala utilidades adicionales:
     - `postgresql-contrib`: Extensiones adicionales de PostgreSQL
     - `vim`: Editor de texto
     - `less`: Paginador de texto
   - Limpia la caché de apt para reducir el tamaño de la imagen

5. **VOLUME**:
   - Define un volumen para persistir los datos de la base de datos
   - Evita la pérdida de datos al reiniciar el contenedor

6. **EXPOSE**:
   - Expone el puerto 5432, que es el puerto estándar de PostgreSQL

7. **CMD**:
   - Comando que se ejecutará al iniciar el contenedor
   - Usa la configuración personalizada especificada en `custom-postgres.conf`

### Personalización del Dockerfile

Puedes modificar las siguientes secciones según tus necesidades:

1. **Versión de PostgreSQL**: Cambia `postgres:15.5` por la versión deseada
2. **Credenciales**: Modifica las variables `POSTGRES_USER`, `POSTGRES_PASSWORD` y `POSTGRES_DB`
3. **Paquetes adicionales**: Añade o quita paquetes en la sección `RUN apt-get install`
4. **Configuración de red**: Ajusta el puerto expuesto si es necesario

## Pasos para la Implementación

### 1. Construir la imagen de Docker
Abre una terminal en el directorio del proyecto y ejecuta:

```bash
docker build -t postgres-tienda .
```

### 2. Ejecutar el contenedor

```bash
docker run -d \
  --name postgres-tienda \
  -p 5432:5432 \
  -v pgdata:/var/lib/postgresql/data \
  postgres-tienda
```

### 3. Verificar la inicialización de la base de datos

#### a) Verificar que el contenedor esté en ejecución
```bash
docker ps
```

#### b) Verificar los logs de inicialización
```bash
docker logs postgres-tienda
```

#### c) Conectarse a la base de datos y verificar las tablas
```bash
docker exec -it postgres-tienda psql -U admin -d defaultdb -c "\dt store.*"
```

Deberías ver la siguiente salida:
```
           List of relations
 Schema |      Name      | Type  | Owner 
--------+----------------+-------+-------
 store  | customers      | table | admin
 store  | order_details  | table | admin
 store  | orders         | table | admin
 store  | products       | table | admin
(4 rows)
```

#### d) Verificar los datos de ejemplo

1. **Clientes**
```bash
docker exec -it postgres-tienda psql -U admin -d defaultdb -c "SELECT * FROM store.customers;"
```

2. **Productos**
```bash
docker exec -it postgres-tienda psql -U admin -d defaultdb -c "SELECT * FROM store.products;"
```

3. **Pedidos**
```bash
docker exec -it postgres-tienda psql -U admin -d defaultdb -c "SELECT * FROM store.orders;"
```

4. **Detalles de pedidos**
```bash
docker exec -it postgres-tienda psql -U admin -d defaultdb -c "SELECT * FROM store.order_details;"
```

#### e) Verificar índices
```bash
docker exec -it postgres-tienda psql -U admin -d defaultdb -c "\di store.*"
```

Deberías ver los índices creados:
```
                    List of relations
 Schema |           Name           | Type  | Table  | Owner 
--------+--------------------------+-------+--------+-------
 store  | customers_pkey           | index | ...    | admin
 store  | idx_orders_customer_id   | index | orders | admin
 store  | idx_order_items_order_id | index | ...    | admin
 store  | order_details_pkey       | index | ...    | admin
 store  | orders_pkey              | index | ...    | admin
 store  | products_pkey            | index | ...    | admin
(6 rows)
```

### 3. Verificar que el contenedor esté en ejecución

```bash
docker ps
```

Deberías ver el contenedor `postgres-tienda` en la lista de contenedores en ejecución.

## Configuración de la Base de Datos

### Credenciales por defecto
- **Usuario:** admin
- **Contraseña:** admin123
- **Base de datos:** defaultdb
- **Puerto:** 5432

### Estructura de la base de datos
Se crea automáticamente un esquema `store` con las siguientes tablas:
- `customers`: Información de clientes
- `products`: Catálogo de productos
- `orders`: Encabezados de pedidos
- `order_details`: Detalles de los pedidos

## Personalización

### Modificar credenciales
Edita el archivo `Dockerfile` y cambia las variables de entorno:
```dockerfile
ENV POSTGRES_USER=tu_usuario
ENV POSTGRES_PASSWORD=tu_contraseña
ENV POSTGRES_DB=nombre_base_datos
```

### Ajustar configuración de PostgreSQL
Modifica el archivo `custom-postgres.conf` según tus necesidades:
```ini
# Número máximo de conexiones concurrentes
max_connections = 200

# Memoria para el buffer compartido
shared_buffers = 256MB

# Habilitar logging
logging_collector = on
log_directory = 'pg_log'
log_filename = 'postgresql-%a.log'
```

## Uso con Aplicaciones

### Cadena de conexión
```
postgresql://admin:admin123@localhost:5432/defaultdb
```

### Conectarse con psql
```bash
docker exec -it postgres-tienda psql -U admin -d defaultdb
```

## Mantenimiento

### Hacer backup de la base de datos
```bash
docker exec -t postgres-tienda pg_dump -U admin -d defaultdb > backup_$(date +%Y%m%d).sql
```

### Restaurar desde un backup
```bash
cat backup_20230908.sql | docker exec -i postgres-tienda psql -U admin -d defaultdb
```

## Solución de Problemas

### Ver logs del contenedor
```bash
docker logs postgres-tienda
```

### Acceder al contenedor
```bash
docker exec -it postgres-tienda bash
```

## Consideraciones de Seguridad
1. Cambia las credenciales por defecto en entornos de producción
2. No expongas el puerto 5432 a Internet sin protección
3. Configura reglas de firewall adecuadas
4. Considera usar volúmenes concriptados para datos sensibles

## Limpieza

### Detener y eliminar el contenedor
```bash
docker stop postgres-tienda
docker rm postgres-tienda
```

### Eliminar la imagen
```bash
docker rmi postgres-tienda
```

### Eliminar volúmenes no utilizados
```bash
docker volume prune
```

---
*Esta guía asume que estás utilizando Docker en un entorno Linux o Windows con WSL2. Los comandos pueden variar ligeramente según tu sistema operativo.*
