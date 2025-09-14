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
##  File      : build-game.sh                                                 ##
##  Project   : cosmic_intruders                                              ##
##  Date      : 2017-11-17                                                    ##
##  License   : GPLv3                                                         ##
##  Author    : mateus.digital <hello@mateus.digital>                         ##
##  Copyright : mateus.digital - 2017 - 2023                                  ##
##                                                                            ##
##  Description :                                                             ##
##    This script builds the pc and web version of Cosmic Intruders.          ##
##    Look for ./install-dependencies.sh to check what's required to          ##
##    run the build.                                                          ##
##---------------------------------------------------------------------------~##

set -e ## break on errors...

##------------------------------------------------------------------------------
function show_help() {
    echo "--pc  ) GAME_BUILD_TARGET=pc";
    echo "--web ) GAME_BUILD_TARGET=web";
    exit 1;
}

## -----------------------------------------------------------------------------
readonly is_linux="$(uname -a | grep -i Linux)";
readonly is_mac="$(uname -a | grep -i Darwin)";
if [ -n "$is_linux" ] ; then
    readonly PLATFORM_NAME="linux";
elif [ -n "$is_mac" ] ; then
    readonly PLATFORM_NAME="macos";
else
    echo "Unknown platform: ${PLATFORM_NAME}";
    exit 1;
fi;

##------------------------------------------------------------------------------
GAME_BUILD_TYPE="release";
GAME_BUILD_TARGET="pc";

while true; do
    case "$1" in
        "--pc"     ) GAME_BUILD_TARGET="$PLATFORM_NAME";   ;;
        "--web"     ) GAME_BUILD_TARGET="web";   ;;
        *) show_help;                            ;;
    esac;
    shift;
    if [ $# -eq 0 ]; then
        break;
    fi;
done;


echo "==> Building for ${GAME_BUILD_TARGET} in (${PLATFORM_NAME})";

##------------------------------------------------------------------------------
readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)";
readonly ROOT_DIR="$(dirname "$SCRIPT_DIR")";

readonly LIBS_ROOT_DIR="${ROOT_DIR}/lib/Cooper";
readonly GAME_ROOT_DIR="${ROOT_DIR}/game";
readonly ASSETS_DIR="${ROOT_DIR}/assets";

readonly GAME_NAME="cosmic-intruders";
readonly GAME_VERSION="0.0.0";

readonly BUILD_DIR="${ROOT_DIR}/_build/${GAME_BUILD_TARGET}-${GAME_BUILD_TYPE}";


##
## Build the game.
##

##------------------------------------------------------------------------------
function build_for_pc()
{
    echo "Building game for pc ${GAME_BUILD_TARGET}-${GAME_BUILD_TYPE}";
    echo "GAME VERSION: ${GAME_VERSION}";
    mkdir -p "${BUILD_DIR}";

    ## @todo(mateus): Add debug option...
    g++                                                                           \
        $(find ${ROOT_DIR} -type d -name "emsdk" -prune -o -iname "*.cpp" -print) \
        $(sdl2-config --cflags)                                                   \
        -std=c++14                                                                \
                                                                                  \
        -I"${LIBS_ROOT_DIR}"                                                      \
        -I"${LIBS_ROOT_DIR}/Cooper"                                               \
        -I"${GAME_ROOT_DIR}"                                                      \
                                                                                  \
        -o "${BUILD_DIR}/${GAME_NAME}"                                            \
                                                                                  \
        $(sdl2-config --libs)                                                     \
        -lSDL2_mixer                                                              \
        -lSDL2_ttf                                                                \
        -lSDL2_image                                                              \
                                                                                  \
        -DGAME_VERSION="\"${GAME_VERSION}\""                                      \
    ;
}

##------------------------------------------------------------------------------
function build_for_web()
{
    source "${ROOT_DIR}/emsdk/emsdk_env.sh";

    echo "Building game for web ${GAME_BUILD_TARGET}-${GAME_BUILD_TYPE}";
    echo "GAME VERSION: ${GAME_VERSION}";
    mkdir -p "${BUILD_DIR}";

    ## @todo(mateus): Add debug option...
    em++                                                                          \
        $(find ${ROOT_DIR} -type d -name "emsdk" -prune -o -iname "*.cpp" -print) \
        -std=c++14                                                                \
        -Oz                                                                       \
                                                                                  \
        -I"${LIBS_ROOT_DIR}"                                                      \
        -I"${LIBS_ROOT_DIR}/Cooper"                                               \
        -I"${GAME_ROOT_DIR}"                                                      \
                                                                                  \
        -o "${BUILD_DIR}/game.html"                                               \
                                                                                  \
        -DEMSCRIPTEN_HAS_UNBOUND_TYPE_NAMES=0                                     \
                                                                                  \
        -s ENVIRONMENT='web'                                                      \
        -s INLINING_LIMIT=1                                                       \
                                                                                  \
        -s ASSERTIONS=0                                                           \
        -s STACK_OVERFLOW_CHECK=0                                                 \
        -s SAFE_HEAP=0                                                            \
        -s LZ4=1                                                                  \
        -s DISABLE_EXCEPTION_CATCHING=1                                           \
        -s AGGRESSIVE_VARIABLE_ELIMINATION=1                                      \
                                                                                  \
        -s USE_SDL=2                                                              \
        -s USE_SDL_TTF=2                                                          \
        -s USE_SDL_IMAGE=2                                                        \
        -s SDL2_IMAGE_FORMATS='["png"]'                                           \
                                                                                  \
                                                                                  \
        -fno-exceptions                                                           \
        -fno-rtti                                                                 \
                                                                                  \
         -lidbfs.js                                                               \
                                                                                  \
        --preload-file assets-web/@assets                                         \
                                                                                  \
        -DGAME_VERSION="\"${GAME_VERSION}\""                                      \
    ;

    ls -lh "${BUILD_DIR}";
}

##------------------------------------------------------------------------------
echo "-=============== ${GAME_BUILD_TARGET}";
if [ "${GAME_BUILD_TARGET}" == "web" ]; then
    build_for_web;
else
    build_for_pc
fi;