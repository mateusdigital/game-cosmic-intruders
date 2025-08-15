#!/usr/bin/env bash
##~---------------------------------------------------------------------------##
##                               *       +                                    ##
##                         '                  |                               ##
##                     ()    .-.,="``"=.    - o -                             ##
##                           '=/_       \     |                               ##
##                        *   |  '=._    |                                    ##
##                             \     `=./`,        '                          ##
##                          .   '=.__.=' `='      *                           ##
##                 +                         +                                ##
##                      O      *        '       .                             ##
##                                                                            ##
##  File      : install-dependencies.sh                                       ##
##  Project   : cosmic_intruders                                              ##
##  Date      : 2023-05-13                                                    ##
##  License   : GPLv3                                                         ##
##  Author    : mateus.digital <hello@mateus.digital>                         ##
##  Copyright : mateus.digital - 2023                                         ##
##                                                                            ##
##  Description :                                                             ##
##     Assumes: git, g++                                                      ##
##              brew (on mac)                                                 ##
##              apt-get (on gnu)                                              ##
##     Downloads: emscripten and SDL2 libs.                                   ##
##---------------------------------------------------------------------------~##

set -e ## break on errors...


readonly is_linux="$(uname -a | grep -i Linux)";
readonly is_mac="$(uname -a | grep -i Darwin)";

if [ -n "$is_linux" ]; then
    echo "==> Installing for linux";
    sudo apt-get update  -y;
    sudo apt-get install -y   \
        g++                   \
        libsdl2-2.0-0         \
        libsdl2-doc           \
        libsdl2-gfx-dev       \
        libsdl2-image-2.0-0   \
        libsdl2-mixer-2.0-0   \
        libsdl2-net-2.0-0     \
        libsdl2-ttf-2.0-0     \
        libsdl2-dev           \
        libsdl2-gfx-1.0-0     \
        libsdl2-gfx-doc       \
        libsdl2-image-dev     \
        libsdl2-mixer-dev     \
        libsdl2-net-dev       \
        libsdl2-ttf-dev       \
        zip                   \
    ;

elif [ -n "$is_mac" ]; then
    echo "==> Installing for mac";
    brew install   \
        SDL2       \
        SDL2_image \
        SDL2_mixer \
        SDL2_ttf   \
        zip        \
    ;
fi;


exit
##
## Emscripten
##

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)";
readonly ROOT_DIR="$(dirname "$SCRIPT_DIR")";

pushd "${ROOT_DIR}";
    echo "==> Clonning EMSDK";
    rm -rf emsdk;
    git clone https://github.com/emscripten-core/emsdk.git;

    pushd emsdk
        git pull;

        ./emsdk install  latest;
        ./emsdk activate latest;

        source "${ROOT_DIR}/emsdk/emsdk_env.sh";
    popd # emsdk
popd # "${ROOT_DIR}";
