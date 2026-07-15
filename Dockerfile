FROM docker.io/openresty/openresty:bookworm-fat@sha256:d9fd06d1b0a0a2f276f30502f2683340b3be7f99a236dfd4e70ce63285ae5577 AS builder

ARG LUA_OIDC_VERSION=1.9.0
RUN luarocks install lua-resty-openidc ${LUA_OIDC_VERSION}

FROM gcr.io/distroless/base-debian12:nonroot@sha256:6c806311d31c11d364a8d13a022af5a48f29e43bd585ad6b51f1bb447f83d239
LABEL org.opencontainers.image.source="https://github.com/claudio4/openresty-oidc-distroless"

COPY --from=builder --chown=nonroot:nonroot /usr/local/openresty /usr/local/openresty
COPY --from=builder /lib/x86_64-linux-gnu/libcrypt.so.1 /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/
COPY --from=builder --chown=nonroot:nonroot /var/run/openresty/ /var/run/openresty/


ENTRYPOINT ["/usr/local/openresty/nginx/sbin/nginx"]
CMD [ "-g", "daemon off;" ]
