#!/bin/bash
set -e

chmod +x install_deps.sh
chmod +x install_deps_simple.sh

echo "Running pixi install..."
pixi install

echo "Setting up additional dependencies and repositories within pixi environment..."
# if you get an error about the package not being found, try running install_deps_simple
# pixi run -e gpu install_deps
pixi run -e gpu install_deps_simple
