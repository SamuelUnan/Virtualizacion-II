
# Guía de instalación Docker Ubuntu

Proceso de instalación para instalar Docker Engine en una Máquina Virtual con Sistema Operativo Ubuntu


## Referencias

 - [Docker Engine Official Ubuntu Install](https://docs.docker.com/engine/install/ubuntu/)


## Características

- Proceso de instalación de Docker Engine
- Instalación desde Paquetes APT
- Comprobación de instalación
- Montar Directorio Compartido Sincronizado


## Instalación

- Actualización de Paquetes del Sistema

```bash
  sudo apt update
  sudo apt upgrade -y
```

- Instalación de Dependencias

```bash
  sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
```

- Agregar clave GPG Oficial de Docker

```bash
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

- Agregar repositorio de Docker

```bash
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

- Actualizar Listado de Paquetes

```bash
  sudo apt update
```

- Instalación de Paquetes de Docker

```bash
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

- Comprobación de instalación

```bash
  sudo docker run hello-world
```
    
## Configuraciones Post Instalación

- Asignar usuario al grupo Docker

```bash
  sudo usermod -aG docker $USER
```

- Verificar estado del Servicio de Docker

```bash
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo systemctl status docker
```

## Proceso de Configuración Directorio Compartido

- Configurar Directorio Compartido en el Host

  1. Crear Carpeta Compartida en Windows
    - Crear el directorio
    - Asignar directorio para compartir en las propiedades
  
  2. Establecer credenciales del usuario de Windows

  3. Obtener IP del Sistema Host

- Configurar montaje en Ubuntu

  1. Instalar dependencias

    ```bash
      sudo apt update
      sudo apt install cifs-utils
    ```

  2. Crear punto de montaje

    ```bash
      sudo mkdir -p /mnt/directorio
    ```
  3. Montar carpeta compartida

    ```bash
      sudo mount -t cifs //IP-DE-WINDOWS/Directorio /mnt/directorio -o username=tu_usuario_windows,password=tu_contraseña,uid=1000,gid=1000
    ```