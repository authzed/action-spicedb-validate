FROM quay.io/authzed/zed:v1.2.1@sha256:075810514ce2b5b494240b8015dd1ee686b47c00e238a5925eaf5f5fe3c8d02e as base

FROM ubuntu:26.04@sha256:d66b366dac61b575bee2aef07e9c26e8070096fbe84a3d4d3eb0da069b5d76db
COPY --from=base /usr/local/bin/zed /zed
RUN chmod +x /zed
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
