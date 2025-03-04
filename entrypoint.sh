#!/bin/sh
set -e

# Run the Rails setup (migrations, gems, etc.)
bin/setup

# Run asset compilation in watch mode
yarn build:css --watch &
yarn build --watch &

# Start the Rails server
exec rails server -b 0.0.0.0
