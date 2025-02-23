FROM ghcr.io/authelia/authelia:master@sha256:e255ef2a72ece2af6a84ff9b516bc50dcd85f112575cc49820d926a5ee84cf02
# latest authelia as of 2024-02-23

ENV X_AUTHELIA_CONFIG_FILTERS="template"

COPY configuration.yml /config/configuration.yml
COPY users_database.yml /config/users_database.yml
