FROM authelia/authelia:4.38.17

ENV X_AUTHELIA_CONFIG_FILTERS="template"

COPY configuration.yml /config/configuration.yml
COPY users_database.yml /config/users_database.yml
