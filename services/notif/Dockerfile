# ---- Stage 1 : build du binaire Go ----
FROM golang:1.22-alpine AS build

WORKDIR /src

# On copie go.mod avant le code pour optimiser le cache Docker.
COPY go.mod ./
RUN go mod download

# Compile le binaire statique (pas de dépendances C).
COPY cmd/ ./cmd/
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /out/notif ./cmd

# ---- Stage 2 : runtime ultra-minimal (distroless) ----
FROM gcr.io/distroless/static:nonroot AS runtime

LABEL org.opencontainers.image.source="https://github.com/Maatrooo/devhub-campus" \
      org.opencontainers.image.description="notif-service — DevHub Campus"

COPY --from=build /out/notif /notif

ENV PORT=8080 \
    LOG_LEVEL=info

EXPOSE 8080

# distroless/static:nonroot tourne déjà en non-root (UID 65532).
ENTRYPOINT ["/notif"]
