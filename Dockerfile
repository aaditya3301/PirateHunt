# ---- Build stage ----
FROM python:3.10-slim AS builder

WORKDIR /app

# Install build deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml requirements.txt ./
COPY src/ ./src/

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -e .

# ---- Runtime stage ----
FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /app /app

# Cloud Run sets PORT env var
ENV PORT=8000

EXPOSE 8000

CMD ["sh", "-c", "python -m piratehunt.api.main --host 0.0.0.0 --port $PORT"]
