FROM quay.io/authzed/zed:v1.2.1@sha256:075810514ce2b5b494240b8015dd1ee686b47c00e238a5925eaf5f5fe3c8d02e as base

FROM ubuntu:22.04@sha256:f64b2ffc2f10ab8f8505aa56b2664bd846cbb9df87c7e2532e30f7667021c0e6
COPY --from=base /usr/local/bin/zed /zed
RUN chmod +x /zed
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
