# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Python client for Gambiarra LLM Club Arena Local, designed to participate in LLM challenges by connecting to an arena server via WebSocket and streaming token-by-token responses using various LLM backends (Ollama, LM Studio, or a mock runner for testing).

## Development Commands

### Installation

Using uv (recommended - much faster):
```bash
# Install uv if you don't have it
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install in development mode
uv pip install -e .

# Install with dev dependencies (includes pytest, black, ruff)
uv pip install -e ".[dev]"
```

Using pip (traditional):
```bash
# Install in development mode
pip install -e .

# Install with dev dependencies (includes pytest, black, ruff)
pip install -e ".[dev]"
```

### Running the Client
```bash
# Quick start with script
./run.sh

# Or with .env configuration (recommended)
cp .env.example .env
# Edit .env with your settings
gambiarra-client

# Or run directly from source (during development)
python -m gambiarra_client.cli

# With CLI arguments (overrides .env)
gambiarra-client --pin 123456 --participant-id test-1 --nickname "Test"
```

### Testing & Code Quality
```bash
# Run tests
pytest

# Format code (line length: 100)
black gambiarra_client/

# Lint code
ruff check gambiarra_client/
```

## Architecture

### Core Components

The codebase follows a modular architecture with three main layers:

1. **CLI Layer** (`cli.py`): Entry point that handles argument parsing, runner initialization, and challenge orchestration. Coordinates between the WebSocket client and the LLM runner.

2. **Network Layer** (`net/ws.py`): WebSocket client (`GambiarraClient`) that manages server connection, message parsing, and automatic reconnection with exponential backoff. Implements event-based handlers for challenges, registration, and disconnection.

3. **Runner Layer** (`runners/`): Abstract `Runner` interface with implementations for different LLM backends:
   - `types.py`: Base `Runner` ABC and shared types (`GenerateOptions`, `TokenCallback`)
   - `ollama.py`: Ollama API integration with streaming support
   - `lmstudio.py`: LM Studio API integration
   - `mock.py`: Mock runner for testing (simulates token generation)

### WebSocket Protocol

The client implements a specific protocol for communication with the arena server:

**Client → Server messages:**
- `register`: Initial registration with participant info, runner type, and model
- `token`: Individual token during generation (includes round, sequence number, content)
- `complete`: Generation completion with metrics (tokens, latency, duration, model info)
- `error`: Error during generation (includes error code and message)

**Server → Client messages:**
- `challenge`: New round with prompt, max_tokens, temperature, deadline_ms, and optional seed
- `heartbeat`: Keep-alive ping
- `registered`: Registration confirmation

### Token Streaming Flow

When a challenge arrives (handled in `cli.py:handle_challenge`):
1. A token callback is registered that sends each token to the server via WebSocket as it's generated
2. The runner's `generate()` method is called with the prompt, options, and callback
3. Metrics are tracked: start time, first token latency, total duration, and token count
4. Upon completion, a `complete` message is sent with all metrics
5. If an error occurs, an `error` message is sent instead

### Runner Interface

All runners must implement:
- `async test()`: Verify the backend is available and responding
- `async generate(prompt, options, on_token)`: Stream tokens via callback, respecting `GenerateOptions` (max_tokens, temperature, seed)

The `on_token` callback is called for each generated token and handles sending it to the server asynchronously.

### Connection Management

The `GambiarraClient` in `net/ws.py` implements:
- Automatic reconnection with exponential backoff (max 5 attempts)
- Event-based architecture using callbacks registered via `client.on(event, callback)`
- Message loop running in a separate async task
- Connection state tracking via `self.running` flag

## Key Implementation Details

- **Async/await throughout**: All I/O operations are asynchronous using `asyncio`
- **Streaming responses**: Runners stream tokens one-by-one via callbacks rather than buffering
- **Metrics collection**: First token latency and total duration are tracked for each generation
- **ANSI colors**: Terminal output uses ANSI color codes defined in `Colors` class for better UX
- **Type hints**: Code uses type hints and dataclasses for message types
- **Python 3.8+**: Minimum Python version is 3.8 (set in pyproject.toml)

## Runner Configuration

Each runner type requires different configuration:

- **Ollama**: Requires `--ollama-url` (default: http://localhost:11434) and `--model`
- **LM Studio**: Requires `--lmstudio-url` (default: http://localhost:1234) and `--model`
- **Mock**: No additional configuration needed, simulates generation for testing

The client tests the runner connection before connecting to the arena server (see `cli.py:167-172`).

## Code Style

- Line length: 100 characters (configured in pyproject.toml for both black and ruff)
- Target: Python 3.8
- Formatting: black
- Linting: ruff

## Important Notes

### Why `pip install -e .` instead of `requirements.txt`?

This project uses `pip install -e .` (or `uv pip install -e .`) to install because:
- It installs the project as a proper Python package
- It registers the `gambiarra-client` command in the PATH (defined in pyproject.toml entry points)
- It installs dependencies from `pyproject.toml` (the modern source of truth)
- The `-e` flag enables "editable" mode so code changes are reflected immediately

**There is no `requirements.txt` file** - all dependencies are defined in `pyproject.toml`. This is the modern Python packaging approach.
