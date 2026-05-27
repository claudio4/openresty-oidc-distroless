FROM docker.io/openresty/openresty:bookworm-fat@sha256:b6304cd4b189aac0944333781efa1e44afd753e4ea04378fdf0fa5273e006c9d AS builder

ARG LUA_OIDC_VERSION=1.8.0
RUN luarocks install lua-resty-openidc ${LUA_OIDC_VERSION}

FROM gcr.io/distroless/base-debian12:nonroot@sha256:7a75a36f4bec82a7542c64195e402907486f9a4dd2f8797a976aa0cf31cfb470
LABEL org.opencontainers.image.source="https://github.com/claudio4/openresty-oidc-distroless"

COPY --from=builder --chown=nonroot:nonroot /usr/local/openresty /usr/local/openresty
COPY --from=builder /lib/x86_64-linux-gnu/libcrypt.so.1 /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/
COPY --from=builder --chown=nonroot:nonroot /var/run/openresty/ /var/run/openresty/


ENTRYPOINT ["/usr/local/openresty/nginx/sbin/nginx"]
CMD [ "-g", "daemon off;" ]
