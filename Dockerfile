FROM alpine:3.22.0

ARG PROMETHEUS_VERSION=PROMETHEUS_VERSION
ARG PROMETHEUS_HOME=/prometheus
ARG PROMETHEUS_TAR=prometheus-${PROMETHEUS_VERSION}.linux-amd64
ARG PROMETHEUS_TAR_FULLNAME=${PROMETHEUS_TAR}.tar.gz
ARG PROMETHEUS_URL=https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/${PROMETHEUS_TAR_FULLNAME}

RUN echo "===> Downloading prometheus..."                           && \
    apk update && apk upgrade                                       && \
    apk add wget && rm -rf /var/cache/apk/*                         && \
    wget ${PROMETHEUS_URL}                                          && \
    tar xvfz ${PROMETHEUS_TAR_FULLNAME} -C /                        && \
    mv /${PROMETHEUS_TAR} /prometheus                               && \
    echo "===> Configuration prometheus..."                         && \
    addgroup -S prometheus && adduser -S prometheus -G prometheus   && \
    chown -R prometheus:prometheus /prometheus                      && \
    rm -rf /${PROMETHEUS_TAR_FULLNAME}
ADD config/prometheus.yml /prometheus/prometheus.yml

RUN echo "===> Download and install python..."                      && \
    apk add --no-cache python3                                      && \
    python3 -m ensurepip                                            && \
    pip3 install --no-cache --upgrade pip setuptools wheel          && \
    pip3 install awscli --upgrade

EXPOSE 9090

WORKDIR ${PROMETHEUS_HOME}

USER prometheus

ENTRYPOINT [ "./prometheus" ]
CMD        [ "--config.file=/prometheus/prometheus.yml", \
    "--storage.tsdb.path=/prometheus", \
    "--web.console.libraries=/usr/share/prometheus/console_libraries", \
    "--web.console.templates=/usr/share/prometheus/consoles" ]