#!/bin/bash

# Script de entrada para Ollama con GPU

echo "========================================="
echo "Iniciando Ollama con GPU NVIDIA"
echo "========================================="

# Verificar GPU NVIDIA
echo "Verificando GPU NVIDIA..."
nvidia-smi

if [ $? -eq 0 ]; then
    echo "✅ GPU NVIDIA detectada correctamente"
    
    # Verificar memoria VRAM
    echo "Memoria VRAM disponible:"
    nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits
else
    echo "❌ No se detectó GPU NVIDIA"
    echo "El contenedor seguirá funcionando en modo CPU"
fi

# Iniciar Ollama en modo servidor
echo ""
echo "Iniciando servidor Ollama..."
echo "El servidor estará disponible en: http://localhost:11434"
echo ""

# Ejecutar Ollama en segundo plano
ollama serve &
OLLAMA_PID=$!

# Esperar a que Ollama se inicie completamente
sleep 5

# Verificar si se especificó un modelo para descargar
if [ ! -z "$OLLAMA_MODEL" ]; then
    echo "Descargando modelo: $OLLAMA_MODEL"
    ollama pull "$OLLAMA_MODEL"
    echo "✅ Modelo $OLLAMA_MODEL descargado correctamente"
fi

# Mantener el contenedor activo
wait $OLLAMA_PID