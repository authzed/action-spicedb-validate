FROM quay.io/authzed/zed:latest as base

FROM ubuntu:22.04
COPY --from=base /usr/local/bin/zed /zed
RUN chmod +x /zed
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["bash", "/entrypoint.sh"]
