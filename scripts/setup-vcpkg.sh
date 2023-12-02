#!/usr/bin/env bash

mkdir -p ~/tmpdir
cd ~/tmpdir || exit
# if vcpkg is there, then rm -rf vcpkg
if [[ -d vcpkg ]]; then
    rm -rf vcpkg
fi
git clone https://github.com/Microsoft/vcpkg.git
./vcpkg/bootstrap-vcpkg.sh
./vcpkg/vcpkg install nlohmann-json
echo ~/tmpdir/vcpkg/scripts/buildsystems/vcpkg.cmake
