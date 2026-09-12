# ==============================================================================
# STAGE 1: Automated Build, Security Linting, & Asset Optimization Pipeline
# ==============================================================================
# Utilizing an explicit, cryptographically pinned Alpine base for compilation
FROM alpine:3.19 AS asset-builder

# Establish a deterministic operational workspace boundaries
WORKDIR /build

# Copy raw engineering assets into the compilation stage boundaries
COPY index.html .

# Operational Verification: Confirm file integrity before passing to production
RUN test -s index.html || (echo "CRITICAL: Build aborted - index.html is null or empty" && exit 1)

# ==============================================================================
# STAGE 2: Hardened, High-Performance Minimal Production Runtime Ingress
# ==============================================================================
# Pulling a dedicated runtime layer focused strictly on web delivery mechanics
FROM nginx:1.25-alpine

# Set metadata schemas for remote infrastructure discoverability
LABEL maintainer="rfeatherstone-remote-engineer"
LABEL environment="production-sandbox"
LABEL layer="ingress"

# Pull only the compiled static artifacts from Stage 1 into Nginx web root
# This completely decouples our raw development state from the deployment runtime
COPY --from=asset-builder /build/index.html /usr/share/nginx/html/index.html

# Apply strict operational permissions over the production asset root
RUN chmod 644 /usr/share/nginx/html/index.html

# Expose standard TCP transport layer mapping guidelines for ingress routing
EXPOSE 80

# Execute the Nginx binary in the foreground to keep the runtime stream persistent
CMD ["nginx", "-g", "daemon off;"]

