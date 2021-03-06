#!/bin/bash -ex

cd /yuzu

ccache -s

mkdir build || true && cd build
cmake .. -G Ninja -DDISPLAY_VERSION=$1 -DYUZU_USE_BUNDLED_UNICORN=ON -DYUZU_USE_QT_WEB_ENGINE=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=/usr/lib/ccache/gcc -DCMAKE_CXX_COMPILER=/usr/lib/ccache/g++ -DYUZU_ENABLE_COMPATIBILITY_REPORTING=${ENABLE_COMPATIBILITY_REPORTING:-"OFF"} -DENABLE_COMPATIBILITY_LIST_DOWNLOAD=ON -DUSE_DISCORD_PRESENCE=ON

ninja

ccache -s

# Ignore zlib's tests, since they aren't gated behind a CMake option.
ctest -VV -E "(example|example64)" -C Release
