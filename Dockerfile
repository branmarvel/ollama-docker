# Dockerfile para Ollama con GPU NVIDIA
# Basado en Ubuntu 22.04 con CUDA 12.2
FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

# Variables de entorno para evitar interacción durante la instalación
ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    sudo \
    systemd \
    systemd-sysv \
    init \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario ollama (no root por seguridad)
RUN useradd -m -s /bin/bash ollama && \
    usermod -aG sudo ollama && \
    echo "ollama ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Instalar Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Crear directorio para modelos y dar permisos
RUN mkdir -p /home/ollama/.ollama && \
    chown -R ollama:ollama /home/ollama/.ollama

# Puerto expuesto para la API de Ollama
EXPOSE 11434

# Cambiar al usuario ollama
USER ollama

# Directorio de trabajo
WORKDIR /home/ollama

# Script de inicio
COPY entrypoint.sh /home/ollama/entrypoint.sh
RUN chmod +x /home/ollama/entrypoint.sh

# Comando de inicio
CMD ["/home/ollama/entrypoint.sh"]