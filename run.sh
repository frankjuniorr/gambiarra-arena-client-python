#!/bin/bash
# Script de execução simplificada do Gambiarra Client

set -e

echo "🎮 Gambiarra Client - Setup"
echo ""

# Verificar se .env existe
if [ ! -f ".env" ]; then
    echo "📝 Arquivo .env não encontrado. Criando a partir do exemplo..."
    cp .env.example .env
    echo ""
    echo "⚠️  Por favor, edite o arquivo .env com suas configurações:"
    echo "   - GAMBIARRA_PIN (obrigatório)"
    echo "   - PARTICIPANT_ID (obrigatório)"
    echo "   - NICKNAME (obrigatório)"
    echo ""
    echo "Depois de editar o .env, execute novamente: ./run.sh"
    exit 0
fi

# Verificar se o pacote está instalado
if ! command -v gambiarra-client &> /dev/null; then
    echo "📦 Instalando o cliente..."

    # Detectar se uv está disponível e usar automaticamente
    if command -v uv &> /dev/null; then
        echo "   Usando uv (mais rápido)..."
        uv pip install -e . || {
            echo "❌ Erro ao instalar com uv. Certifique-se de ter Python 3.8+ instalado."
            exit 1
        }
    else
        echo "   Usando pip..."
        echo "   💡 Dica: instale 'uv' para instalação mais rápida (https://github.com/astral-sh/uv)"
        pip install -e . || {
            echo "❌ Erro ao instalar. Certifique-se de ter Python 3.8+ instalado."
            exit 1
        }
    fi

    echo "✅ Cliente instalado com sucesso!"
    echo ""
fi

# Verificar se Ollama está rodando (apenas aviso, não bloqueia)
if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo "⚠️  Ollama não está respondendo em http://localhost:11434"
    echo "   Se você estiver usando Ollama, inicie com: ollama serve"
    echo "   Ou configure RUNNER=mock no .env para testar sem Ollama"
    echo ""
fi

echo "🚀 Iniciando cliente..."
echo ""

# Executar o cliente
gambiarra-client
