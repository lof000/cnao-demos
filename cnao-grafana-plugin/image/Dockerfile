FROM grafana/grafana-oss:9.1.3

ENV GF_PLUGINS_ALLOW_LOADING_UNSIGNED_PLUGINS="appdynamicscloud" \
    GF_PATHS_PLUGINS="/usr/share/grafana/grafana-plugins" \
    GF_SERVER_ROOT_URL="%(protocol)s://%(domain)s:%(http_port)s/grafanaplugin/" \
    GF_SERVER_SERVE_FROM_SUB_PATH="true"

WORKDIR /usr/share/grafana
USER root
RUN mkdir -p /usr/share/grafana/grafana-plugins
COPY appdynamicscloud /usr/share/grafana/grafana-plugins/appdynamicscloud
EXPOSE 3000
USER grafana
WORKDIR /
ENTRYPOINT [ "/run.sh" ]
