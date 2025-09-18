#!/bin/bash

# Exit on error
set -e

# Config variables - change these as per your setup
USER=ubuntu
HOST=your-server-ip
APP_DIR=/var/www/react-app   # folder on remote server

echo "?? Deploying React build to $HOST..."

# Build before deploy
./build.sh

# Copy build files to server
rsync -avz --delete build/ $USER@$HOST:$APP_DIR/

echo "? Deployment completed at $HOST:$APP_DIR"
