# Guía Rápida de Inicio - Ollama con GPU NVIDIA

## 🚀 Inicio Rápido en 3 Pasos

### Paso 1: Verificar Requisitos
```bash
# Verificar GPU NVIDIA
nvidia-smi

# Verificar Docker con GPU
docker run --rm --gpus all nvidia/cuda:12.2.0-devel-ubuntu22.04 nvidia-smi
```

### Paso 2: Configurar y Ejecutar
```bash
# Hacer ejecutable el script
chmod +x scripts/ollama-manager.sh

# Verificar requisitos
./scripts/ollama-manager.sh check

# Iniciar Ollama
./scripts/ollama-manager.sh up
```

### Paso 3: Descargar Modelo y Probar
```bash
# Descargar modelo recomendado para 16GB VRAM
./scripts/ollama-manager.sh download deepseek-coder:6.7b

# Probar que funciona
./scripts/ollama-manager.sh test

# Usar el modelo
./scripts/ollama-manager.sh exec ollama run deepseek-coder:6.7b
```

## 📋 Comandos Esenciales

```bash
# Iniciar servicio
./scripts/ollama-manager.sh up

# Ver logs
docker-compose logs -f

# Descargar modelos
./scripts/ollama-manager.sh download mistral:7b
./scripts/ollama-manager.sh download codellama:7b
./scripts/ollama-manager.sh download llama2:7b

# Listar modelos instalados
./scripts/ollama-manager.sh list

# Ejecutar comando en el contenedor
./scripts/ollama-manager.sh exec ollama list

# Detener servicio
./scripts/ollama-manager.sh down
```

## 💻 Uso Básico

### Interactivo
```bash
# Iniciar sesión interactiva con el modelo
./scripts/ollama-manager.sh exec ollama run deepseek-coder:6.7b

# Dentro del contenedor:
# >>> Escribe tu pregunta aquí
```

### API REST
```bash
# Generar código
curl http://localhost:11434/api/generate -d '{
  "model": "deepseek-coder:6.7b",
  "prompt": "Crea una función en Python que calcule el factorial"
}'

# Chat conversacional
curl http://localhost:11434/api/chat -d '{
  "model": "deepseek-coder:6.7b",
  "messages": [{"role": "user", "content": "Explícame la recursión"}]
}'
```

## 🔧 Solución de Problemas Rápida

### GPU No Detectada
```bash
# Reiniciar Docker con NVIDIA
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Verificar nuevamente
docker run --rm --gpus all nvidia/cuda:12.2.0-devel-ubuntu22.04 nvidia-smi
```

### Modelo No Responde
```bash
# Verificar que el servicio está activo
curl http://localhost:11434/api/tags

# Verificar memoria GPU
watch -n 1 nvidia-smi

# Reiniciar si es necesario
./scripts/ollama-manager.sh down
./scripts/ollama-manager.sh up
```

## 🎯 Modelos Recomendados para 16GB VRAM

| Modelo | Tamaño | Uso Principal | Comando |
|--------|--------|---------------|---------|
| deepseek-coder:6.7b | 4.1GB | Programación | `download deepseek-coder:6.7b` |
| mistral:7b | 4.1GB | General | `download mistral:7b` |
| codellama:7b | 3.8GB | Código | `download codellama:7b` |
| llama2:7b | 3.8GB | General | `download llama2:7b` |

## 📍 Endpoints Importantes

- **API Ollama**: `http://localhost:11434`
- **Web UI** (si habilitado): `http://localhost:3000`
- **Health Check**: `http://localhost:11434/api/tags`

## 🎉 ¡Listo!

Una vez completados estos pasos, tendrás Ollama funcionando con tu GPU NVIDIA y podrás:

1. ✅ Generar código con modelos especializados
2. ✅ Usar la API REST para integraciones
3. ✅ Múltiples modelos disponibles
4. ✅ Persistencia de modelos entre reinicios
5. ✅ Monitoreo de uso de GPU

Para más detalles, consulta el archivo `README.md` completo.