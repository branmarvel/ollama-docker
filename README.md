# Ollama con GPU NVIDIA - Docker Setup

Configuración completa de Ollama con soporte GPU NVIDIA usando Docker y Docker Compose.

## 📋 Requisitos Previos

### Hardware
- GPU NVIDIA con al menos 6GB de VRAM (recomendado 16GB para modelos grandes)
- 8GB de RAM del sistema (mínimo)
- 20GB de espacio en disco para modelos

### Software
- Docker 20.10+
- Docker Compose 2.0+
- NVIDIA Container Toolkit
- NVIDIA Drivers 470+

## 🚀 Instalación Rápida

### 1. NVIDIA Container Toolkit
```bash
# Para Ubuntu/Debian
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

### 2. Verificar Instalación
```bash
# Verificar GPU
nvidia-smi

# Verificar Docker con NVIDIA
docker run --rm --gpus all nvidia/cuda:11.0.3-base-ubuntu20.04 nvidia-smi
```

## 📦 Uso

### Iniciar Ollama
```bash
# Hacer el script ejecutable
chmod +x scripts/ollama-manager.sh

# Iniciar el servicio
./scripts/ollama-manager.sh up
```

### Descargar Modelos
```bash
# Modelos recomendados para 16GB VRAM:
./scripts/ollama-manager.sh download deepseek-coder:6.7b    # Programación
./scripts/ollama-manager.sh download deepseek-llm:7b        # General
./scripts/ollama-manager.sh download codellama:7b           # Código
./scripts/ollama-manager.sh download mistral:7b             # General
./scripts/ollama-manager.sh download llama2:7b              # General
```

### Probar Ollama
```bash
# Verificar que funciona
./scripts/ollama-manager.sh test

# Ejecutar modelo interactivo
./scripts/ollama-manager.sh exec ollama run deepseek-coder:6.7b
```

## 🛠️ Configuración Personalizada

### Variables de Entorno
Edita el archivo `.env` para personalizar:

```bash
# Modelo a descargar automáticamente
OLLAMA_MODEL=deepseek-coder:6.7b

# Configuración del servidor
OLLAMA_HOST=0.0.0.0
OLLAMA_PORT=11434
```

### Modelos Disponibles
Para 16GB VRAM puedes usar:
- **deepseek-coder:6.7b** - Especializado en programación
- **deepseek-llm:7b** - Modelo general
- **codellama:7b** - Optimizado para código
- **mistral:7b** - Alto rendimiento general
- **llama2:7b** - Modelo general
- **vicuna:7b** - Chat optimizado

## 📡 API REST

Ollama expone una API REST en `http://localhost:11434`:

### Ejemplos de uso:
```bash
# Listar modelos
curl http://localhost:11434/api/tags

# Generar respuesta
curl http://localhost:11434/api/generate -d '{
  "model": "deepseek-coder:6.7b",
  "prompt": "¿Cuál es la complejidad del quicksort?"
}'

# Chat conversacional
curl http://localhost:11434/api/chat -d '{
  "model": "deepseek-coder:6.7b",
  "messages": [
    {"role": "user", "content": "Explícame la recursión"}
  ]
}'
```

## 🔧 Comandos Útiles

### Gestión del Contenedor
```bash
# Ver estado
docker-compose ps

# Ver logs
docker-compose logs -f

# Detener
docker-compose down

# Reiniciar
docker-compose restart
```

### Gestión de Modelos
```bash
# Listar modelos
docker-compose exec ollama ollama list

# Descargar modelo
docker-compose exec ollama ollama pull mistral:7b

# Eliminar modelo
docker-compose exec ollama ollama rm modelo:nombre

# Copiar modelo desde host
docker cp modelo.bin ollama-gpu:/home/ollama/.ollama/models/
```

## 🐛 Solución de Problemas

### GPU No Detectada
```bash
# Verificar NVIDIA Container Toolkit
nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Verificar GPU en Docker
docker run --rm --gpus all nvidia/cuda:12.2.0-devel-ubuntu22.04 nvidia-smi
```

### Problemas de Memoria
```bash
# Aumentar límite de memoria en docker-compose.yml
mem_limit: 16g

# Verificar uso de memoria
docker stats
```

### Logs y Depuración
```bash
# Ver logs completos
docker-compose logs -f ollama

# Verificar configuración
docker-compose config

# Ejecutar en modo interactivo
docker-compose run --rm ollama bash
```

## 📁 Estructura de Archivos

```
.
├── Dockerfile              # Imagen de Docker
├── docker-compose.yml      # Configuración del servicio
├── .env                    # Variables de entorno
├── entrypoint.sh          # Script de inicio
├── scripts/
│   └── ollama-manager.sh  # Script de gestión
└── README.md              # Este archivo
```

## 🔒 Seguridad

- El contenedor ejecuta con usuario no-root (`ollama`)
- Los modelos se almacenan en volúmenes nombrados para persistencia
- Solo el puerto 11434 está expuesto externamente
- La GPU es accesible solo dentro del contenedor

## 📊 Monitoreo

### Uso de GPU
```bash
# Ver uso de GPU
watch -n 1 nvidia-smi

# Ver estadísticas
docker stats
```

### Rendimiento
```bash
# Benchmark de modelos
docker-compose exec ollama ollama run deepseek-coder:6.7b "Evalúa este código:"
```

## 🔄 Actualización

```bash
# Detener servicio
docker-compose down

# Actualizar imagen
docker-compose build --no-cache

# Reiniciar
docker-compose up -d
```

## 📚 Recursos Adicionales

- [Documentación Ollama](https://ollama.ai)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/)
- [Modelos disponibles](https://ollama.ai/library)
- [API REST](https://ollama.ai/blog/api)

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.