#!/bin/bash

# Script de gestión para Ollama con Docker
# Uso: ./ollama-manager.sh [comando]

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones de ayuda
print_header() {
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Función para verificar requisitos
check_requirements() {
    print_header "Verificando requisitos"
    
    # Verificar Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker no está instalado"
        exit 1
    fi
    print_success "Docker está instalado"
    
    # Verificar Docker Compose
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_error "Docker Compose no está instalado"
        exit 1
    fi
    print_success "Docker Compose está instalado"
    
    # Verificar NVIDIA Docker
    if ! docker info | grep -q "nvidia"; then
        print_warning "NVIDIA Docker runtime no detectado"
        echo "Instala NVIDIA Container Toolkit:"
        echo "https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html"
    else
        print_success "NVIDIA Docker runtime detectado"
    fi
    
    # Verificar GPU NVIDIA
    if ! nvidia-smi &> /dev/null; then
        print_warning "No se detectó GPU NVIDIA en el sistema host"
    else
        print_success "GPU NVIDIA detectada"
        nvidia-smi --query-gpu=name,memory.total --format=csv,noheader
    fi
}

# Función para construir e iniciar
dev_up() {
    print_header "Construyendo e iniciando Ollama"
    
    # Cargar variables de entorno
    if [ -f .env ]; then
        export $(cat .env | xargs)
    fi
    
    # Construir y ejecutar
    docker-compose up -d --build
    
    print_success "Contenedor iniciado correctamente"
    echo ""
    echo "Servicios disponibles:"
    echo "- Ollama API: http://localhost:11434"
    echo "- Web UI: http://localhost:3000 (si habilitado)"
    echo ""
    echo "Para ver logs: docker-compose logs -f"
}

# Función para detener
dev_down() {
    print_header "Deteniendo Ollama"
    docker-compose down
    print_success "Contenedor detenido"
}

# Función para ver logs
dev_logs() {
    docker-compose logs -f
}

# Función para ejecutar comandos en el contenedor
dev_exec() {
    docker-compose exec ollama "$@"
}

# Función para descargar modelos
download_model() {
    if [ -z "$1" ]; then
        print_error "Por favor especifica un modelo"
        echo "Ejemplos:"
        echo "  ./ollama-manager.sh download deepseek-coder:6.7b"
        echo "  ./ollama-manager.sh download codellama:7b"
        echo "  ./ollama-manager.sh download mistral:7b"
        exit 1
    fi
    
    print_header "Descargando modelo: $1"
    docker-compose exec ollama ollama pull "$1"
    print_success "Modelo descargado correctamente"
}

# Función para listar modelos
list_models() {
    print_header "Modelos disponibles"
    docker-compose exec ollama ollama list
}

# Función para probar Ollama
test_ollama() {
    print_header "Probando Ollama"
    
    # Esperar a que el servicio esté listo
    echo "Esperando a que Ollama esté listo..."
    sleep 10
    
    # Probar conectividad
    if curl -f http://localhost:11434/api/tags &> /dev/null; then
        print_success "Ollama está funcionando correctamente"
        
        # Listar modelos disponibles
        echo ""
        list_models
    else
        print_error "No se puede conectar a Ollama"
        echo "Verifica los logs con: ./ollama-manager.sh logs"
    fi
}

# Función de ayuda
show_help() {
    print_header "Gestor de Ollama - Comandos disponibles"
    echo ""
    echo "Uso: ./ollama-manager.sh [comando]"
    echo ""
    echo "Comandos:"
    echo "  up           - Construir e iniciar el contenedor"
    echo "  down         - Detener el contenedor"
    echo "  logs         - Ver logs del contenedor"
    echo "  exec [cmd]   - Ejecutar comando en el contenedor"
    echo "  download [modelo] - Descargar un modelo"
    echo "  list         - Listar modelos instalados"
    echo "  test         - Probar que Ollama funciona"
    echo "  check        - Verificar requisitos del sistema"
    echo "  help         - Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  ./ollama-manager.sh up"
    echo "  ./ollama-manager.sh download deepseek-coder:6.7b"
    echo "  ./ollama-manager.sh exec ollama run codellama:7b"
    echo "  ./ollama-manager.sh test"
}

# Main
main() {
    case "${1:-help}" in
        "up")
            check_requirements
            dev_up
            ;;
        "down")
            dev_down
            ;;
        "logs")
            dev_logs
            ;;
        "exec")
            shift
            dev_exec "$@"
            ;;
        "download")
            download_model "$2"
            ;;
        "list")
            list_models
            ;;
        "test")
            test_ollama
            ;;
        "check")
            check_requirements
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# Ejecutar main
main "$@"