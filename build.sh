#!/bin/bash

# Exit on error
set -e

echo "?? Starting React build..."

# Clean old build
rm -rf build

# Install dependencies
npm install

# Build React app
npm run build

echo "? React build completed. Build files are in the 'build/' directory."
