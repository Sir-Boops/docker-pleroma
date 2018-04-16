#!/bin/ash

MODE=`printenv RUN_MODE`

if [ $MODE == "PROD" ]; then
    su - -s /bin/ash pleroma -c 'cd pleroma && MIX_ENV=prod mix ecto.migrate'
    su - -s /bin/ash pleroma -c 'cd pleroma && MIX_ENV=prod mix phx.server'
else
    su - -s /bin/ash pleroma -c 'cd pleroma && mix ecto.migrate'
    su - -s /bin/ash pleroma -c 'cd pleroma && mix phx.server'
fi
