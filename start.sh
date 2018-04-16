#!/bin/ash
su - -s /bin/ash pleroma -c 'cd pleroma && mix ecto.migrate'
su - -s /bin/ash pleroma -c 'cd pleroma && mix phx.server'
