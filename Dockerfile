FROM ghcr.io/authelia/authelia:master@sha256:c03958869cb44e4c7fd6783f17e6bc832fb506147ae274470cd60ed7946b56c4
# latest authelia as of 2024-02-23

ENV X_AUTHELIA_CONFIG_FILTERS="template"

COPY configuration.yml /config/configuration.yml
COPY users_database.yml /config/users_database.yml
