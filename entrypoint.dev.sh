#!/bin/bash

mix local.hex --force
mix local.rebar --force
mix ecto.setup
iex -S mix phx.server
