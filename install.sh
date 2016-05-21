#!/bin/bash
git clone https://github.com/kikito/bump.lua.git libs/bump &>/dev/null || echo "Bump already installed"
git clone https://github.com/karai17/Simple-Tiled-Implementation.git libs/STI &>/dev/null || echo "STI already installed"
git clone https://github.com/kikito/inspect.lua.git libs/inspect &>/dev/null || echo "Inspect already installed"
git clone https://github.com/EmmanuelOga/easing.git libs/easing &>/dev/null || echo "Easing already installed"
