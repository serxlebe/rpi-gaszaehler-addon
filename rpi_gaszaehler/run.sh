#!/usr/bin/with-contenv bashio

GPIO_PIN=$(bashio::config 'gpio_pin')
GASZAEHLER_LOG_LEVEL=$(bashio::config 'log_level')

export GPIO_PIN
export GASZAEHLER_LOG_LEVEL

# MQTT-Zugangsdaten, sofern ein MQTT-Add-on (z. B. Mosquitto) läuft und
# "services: mqtt:want" in der config.yaml gesetzt ist.
if bashio::services.available "mqtt"; then
    export MQTT_HOST=$(bashio::services "mqtt" "host")
    export MQTT_PORT=$(bashio::services "mqtt" "port")
    export MQTT_USER=$(bashio::services "mqtt" "username")
    export MQTT_PASSWORD=$(bashio::services "mqtt" "password")
    bashio::log.info "MQTT-Verbindung gefunden: ${MQTT_HOST}:${MQTT_PORT}"
else
    bashio::log.warning "Kein MQTT-Add-on gefunden – Werte werden ggf. nicht an HA übertragen."
fi

bashio::log.info "Starte rpi-gaszaehler auf GPIO_PIN=${GPIO_PIN}"

exec /usr/bin/rpi-gaszaehler
