# =========================
# STAGE 1 — builder
# =========================
FROM python:3.12-slim AS builder

# System deps za build (psycopg2!)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Kopiramo samo requirements (boljši cache)
COPY requirements.txt .

# Buildamo wheel-e (nič installanja v ta image)
RUN pip install --upgrade pip \
    && pip wheel --no-cache-dir --no-deps -r requirements.txt -w /wheels


# =========================
# STAGE 2 — runtime
# =========================
FROM python:3.12-slim

# Samo runtime dependency (Postgres client lib)
RUN apt-get update && apt-get install -y \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Kopiramo wheel-e iz builderja
COPY --from=builder /wheels /wheels

# Install iz wheel-ov (hitro + brez builda)
RUN pip install --upgrade pip \
    && pip install --no-cache-dir /wheels/*

# Kopiramo aplikacijo
COPY . .

EXPOSE 5001

CMD ["python", "main.py"]
