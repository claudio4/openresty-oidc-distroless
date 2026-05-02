FROM docker.io/openresty/openresty:bookworm-fat@sha256:d6e7033191bab0efaa203b35bb3f398c1f5f1bac0ad85885347d44f82b9ac55f AS builder

ARG LUA_OIDC_VERSION=1.8.0
RUN luarocks install lua-resty-openidc ${LUA_OIDC_VERSION}

FROM gcr.io/distroless/base-debian12:nonroot@sha256:a7af3ef5d69f6534ba0492cc7d6b8fbcffddcb02511b45becc2fac752f907584
LABEL org.opencontainers.image.source="https://github.com/claudio4/openresty-oidc-distroless"

COPY --from=builder --chown=nonroot:nonroot /usr/local/openresty /usr/local/openresty
COPY --from=builder /lib/x86_64-linux-gnu/libcrypt.so.1 /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/
COPY --from=builder --chown=nonroot:nonroot /var/run/openresty/ /var/run/openresty/


ENTRYPOINT ["/usr/local/openresty/nginx/sbin/nginx"]
CMD [ "-g", "daemon off;" ]
