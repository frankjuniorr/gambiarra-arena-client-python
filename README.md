# Gambiarra Client - Python

Cliente Python para Gambiarra LLM Club Arena Local.

## Quick Start

**Opção mais fácil** - Use o script automático:

```bash
./run.sh
```

O script vai:
1. Criar o `.env` se não existir (você edita depois)
2. Instalar o cliente automaticamente
3. Verificar se o Ollama está rodando
4. Executar o cliente

**Ou manualmente:**

```bash
# 1. Instale o cliente (escolha um)
pip install -e .          # Usando pip (padrão)
uv pip install -e .       # Usando uv (mais rápido, recomendado)

# 2. Configure suas credenciais
cp .env.example .env
# Edite o .env com seu PIN e informações

# 3. Execute
gambiarra-client
```

## Pré-requisitos

- **Python 3.8+**
- **Ollama** (ou LM Studio) instalado e rodando
- Modelo baixado no Ollama: `ollama pull llama3.1:8b`
- **Opcional:** [uv](https://github.com/astral-sh/uv) para instalação mais rápida

## Instalação Detalhada

### Usando uv (Recomendado - Muito mais rápido)

```bash
# Instalar uv (se ainda não tem)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Instalar o cliente
uv pip install -e .

# Ou com dependências de desenvolvimento
uv pip install -e ".[dev]"
```

### Usando pip (Tradicional)

```bash
# Instalar o cliente
pip install -e .

# Ou com dependências de desenvolvimento
pip install -e ".[dev]"
```

## Configuração

Copie o arquivo de exemplo e edite com suas informações:

```bash
cp .env.example .env
```

Edite o `.env` e preencha:
- `GAMBIARRA_PIN`: PIN da sessão (fornecido pelo organizador)
- `PARTICIPANT_ID`: Seu identificador único
- `NICKNAME`: Seu nome de exibição
- `MODEL`: Modelo do Ollama que você quer usar

## Executar

### Com arquivo .env (Recomendado)

```bash
gambiarra-client
```

O cliente carrega automaticamente as configurações do `.env`.

### Com argumentos CLI (opcional)

Se preferir, pode passar as configurações via linha de comando (sobrescreve o `.env`):

```bash
gambiarra-client \
  --pin 123456 \
  --participant-id meu-cliente \
  --nickname "Meu Nome" \
  --runner ollama \
  --model llama3.1:8b
```

## Desenvolvimento

```bash
# Rodar testes
pytest

# Formatar código
black gambiarra_client/

# Verificar linting
ruff check gambiarra_client/

# Rodar diretamente (sem instalar)
python -m gambiarra_client.cli --help
```

## Avançado

### Docker (Opcional)

Se preferir rodar com Docker Compose:

```bash
# Editar .env e ajustar URLs para Docker:
# GAMBIARRA_URL=ws://host.docker.internal:3000/ws (Mac/Windows)
# OLLAMA_URL=http://ollama:11434

cd scripts
chmod +x *.sh
./start-client.sh

# em outro terminal, execute
./start-round.sh
```

**Nota:** Docker adiciona complexidade de networking. Recomendamos execução local para facilitar.

### Opções CLI Completas

```
--url                WebSocket server URL
--pin                Session PIN
--participant-id     Participant ID
--nickname           Participant nickname
--runner             Runner: ollama, lmstudio, mock
--model              Model name
--temperature        Temperature (default: 0.8)
--max-tokens         Max tokens (default: 400)
--ollama-url         Ollama URL (default: http://localhost:11434)
--lmstudio-url       LM Studio URL (default: http://localhost:1234)
```

## Licença

MIT
