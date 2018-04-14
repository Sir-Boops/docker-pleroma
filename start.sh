#!/bin/ash
cd /opt/pleroma
mix ecto.migrate
mix phx.server
