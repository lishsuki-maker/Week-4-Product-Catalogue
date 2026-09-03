# Stage 1: build
FROM nginx:1.26.2-alpine AS builder

COPY index.html /usr/share/nginx/html/index.html
RUN test -s /usr/share/nginx/html/index.html

# Stage 2: runtime
FROM nginx:1.26.2-alpine

# Create a non-root user
RUN adduser -D -u 1001 appuser

COPY --from=builder /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# hadolint ignore=DL3066
USER 1001 

EXPOSE 80

# Healthcheck
HEALTHCHECK --interval=10s --timeout=3s --retries=5 \
    CMD ["wget", "--spider", "-q", "http://127.0.0.1:80"]

ENTRYPOINT ["/entrypoint.sh"]
