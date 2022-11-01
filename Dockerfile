FROM alpine:3.16

ARG PROMETHEUS_VERSION=PROMETHEUS_VERSION
ARG PROMETHEUS_HOME=/prometheus
ARG PROMETHEUS_TAR=prometheus-${PROMETHEUS_VERSION}.linux-amd64
ARG PROMETHEUS_TAR_FULLNAME=${PROMETHEUS_TAR}.tar.gz
ARG PROMETHEUS_URL=https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/${PROMETHEUS_TAR_FULLNAME}


RUN apk update \ 
    apk upgrade
RUN apk add wget && rm -rf /var/cache/apk/*
RUN wget ${PROMETHEUS_URL}
RUN tar xvfz ${PROMETHEUS_TAR_FULLNAME} -C / && \
    mv /${PROMETHEUS_TAR} /prometheus
RUN addgroup -S prometheus && adduser -S prometheus -G prometheus
RUN chown -R prometheus:prometheus /prometheus
ADD config/prometheus.yml /prometheus/prometheus.yml

RUN rm -rf /${PROMETHEUS_TAR_FULLNAME}
RUN apk add --no-cache python3
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools wheel
RUN pip3 install awscli --upgrade
EXPOSE 9090
WORKDIR ${PROMETHEUS_HOME}

USER prometheus

ENTRYPOINT [ "./prometheus" ]
CMD        [ "--config.file=/prometheus/prometheus.yml", \
    "--storage.tsdb.path=/prometheus", \
    "--web.console.libraries=/usr/share/prometheus/console_libraries", \
    "--web.console.templates=/usr/share/prometheus/consoles" ]