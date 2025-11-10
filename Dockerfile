FROM python:3.11-slim

WORKDIR /app

# Copy project files
COPY pyproject.toml setup.py ./
COPY gambiarra_client/ ./gambiarra_client/

# Install the package
RUN pip install --no-cache-dir -e .

# Set the entrypoint
ENTRYPOINT ["gambiarra-client"]
