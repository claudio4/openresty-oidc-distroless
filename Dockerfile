FROM docker.io/openresty/openresty:bookworm-fat@sha256:1b9d2dc36ce8d8f1ba9a78252d078c0992c96fc0f7e07222f6c4342d755553e7 AS builder

ARG LUA_OIDC_VERSION=1.9.2
RUN luarocks install lua-resty-openidc ${LUA_OIDC_VERSION}

FROM gcr.io/distroless/base-debian12:nonroot@sha256:7f0c72cd138b442ae0deeb69c08b1acf5525439ba251a49ad93c320a061567e5
LABEL org.opencontainers.image.source="https://github.com/claudio4/openresty-oidc-distroless"

COPY --from=builder --chown=nonroot:nonroot /usr/local/openresty /usr/local/openresty
COPY --from=builder /lib/x86_64-linux-gnu/libcrypt.so.1 /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/
COPY --from=builder --chown=nonroot:nonroot /var/run/openresty/ /var/run/openresty/


ENTRYPOINT ["/usr/local/openresty/nginx/sbin/nginx"]
CMD [ "-g", "daemon off;" ]
