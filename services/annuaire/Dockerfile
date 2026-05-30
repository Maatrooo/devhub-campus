# ---- Stage 1 : build / install des dépendances ----
# node:20-alpine pincé sur un tag immuable (pas de `latest`)
FROM node:20-alpine AS build

WORKDIR /app

# On copie package.json AVANT le code source pour profiter du cache Docker :
# si le code change mais pas les deps, npm ci n'est pas rejoué.
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Ensuite seulement on copie le code.
COPY src/ ./src/

# ---- Stage 2 : image runtime ----
# On repart d'une image Alpine minimale : aucun binaire de build inutile.
FROM node:20-alpine AS runtime

LABEL org.opencontainers.image.source="https://github.com/Maatrooo/devhub-campus" \
      org.opencontainers.image.description="annuaire-service — DevHub Campus" \
      org.opencontainers.image.licenses="MIT"

WORKDIR /app

# On ne copie que node_modules et src — rien d'autre du stage build.
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/src ./src

# Utilisateur non-root : UID 1001 (doit correspondre au securityContext K8s).
RUN addgroup -S appgroup && adduser -S appuser -u 1001 -G appgroup
USER 1001

ENV PORT=8080 \
    LOG_LEVEL=info \
    NODE_ENV=production

EXPOSE 8080

CMD ["node", "src/index.js"]
