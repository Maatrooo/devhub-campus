# ---- Stage 1 : install des dépendances ----
FROM python:3.12-slim AS build

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ---- Stage 2 : image runtime ----
FROM python:3.12-slim AS runtime

LABEL org.opencontainers.image.source="https://github.com/Maatrooo/devhub-campus" \
      org.opencontainers.image.description="planning-service — DevHub Campus"

WORKDIR /app

COPY --from=build /install /usr/local
COPY app/ ./app/

RUN groupadd -r appgroup && useradd -r -u 1001 -g appgroup appuser
USER 1001

ENV PORT=8080 \
    LOG_LEVEL=info

EXPOSE 8080

CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
