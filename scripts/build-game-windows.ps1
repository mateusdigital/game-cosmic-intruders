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
##  File      : build-game.ps1                                                ##
##  Project   : cosmic_intruders                                              ##
##  Date      : 2023-06-06                                                    ##
##  License   : GPLv3                                                         ##
##  Author    : mateus.digital <hello@mateus.digital>                         ##
##  Copyright : mateus.digital - 2023, 2025                                   ##
##                                                                            ##
##  Description :                                                             ##
##    This builds the game using mingw -                                      ##
##       It tries to replicate the most of ./scripts/build-game.sh            ##
##    Requires that mingw to be located at: C:/MinGW                          ##
##---------------------------------------------------------------------------~##

$ErrorActionPreference = "Stop"

## -----------------------------------------------------------------------------
$OUTPUT_DIR_PATH = "./_build/windows-release";
## -----------------------------------------------------------------------------
if(-not $env:MINGW_BIN) {
  $_MINGW_BIN = "./thirdparty/MinGW/bin";
  Write-Host "MINGW_BIN not set, using default: $_MINGW_BIN";
} else {
  $_MINGW_BIN = $env:MINGW_BIN;
  Write-Host "MINGW_BIN set to: $_MINGW_BIN";
}

$env:Path = "${_MINGW_BIN};${env:Path}";

## -----------------------------------------------------------------------------

## --- Game version ----------------------------------------------------------
$GAME_VERSION  = $PACKAGE_JSON.version;
$BUILD_VERSION = $PACKAGE_JSON.build;
$FULL_GAME_VERSION = "$GAME_VERSION($BUILD_VERSION)";


Write-Host "==> Building for Windows";
Write-Host "GAME VERSION: ${GAME_VERSION}";


## -----------------------------------------------------------------------------
if (Test-Path "$OUTPUT_DIR_PATH") {
  Remove-Item "$OUTPUT_DIR_PATH" -Recurse -Force;
}
New-Item "$OUTPUT_DIR_PATH" -Type Directory -Force;

## -----------------------------------------------------------------------------
$ALL_SOURCES = Get-ChildItem  `
  -Filter *.cpp -Recurse -ErrorAction SilentlyContinue -Force `
  -Path "./game", "./lib"


g++.exe --verbose                                                           `
  $ALL_SOURCES                                                              `
  -O3 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wfloat-equal          `
  -std=c++14                                                                `
                                                                            `
  -I./lib/SDL2-devel-2.26.5-mingw/i686-w64-mingw32/include/SDL2             `
  -I./lib/SDL2_image-2.6.3-mingw/i686-w64-mingw32/include/SDL2              `
  -I./lib/SDL2_mixer-2.6.3-mingw/i686-w64-mingw32/include/SDL2              `
  -I./lib/SDL2_ttf-2.20.2-mingw/i686-w64-mingw32/include/SDL2               `
                                                                            `
  -I./lib                                                                   `
  -I./lib/Cooper                                                            `
  -I./lib/Cooper/Cooper                                                     `
  -I./game                                                                  `
                                                                            `
  -L./lib/SDL2-devel-2.26.5-mingw/i686-w64-mingw32/lib                      `
  -L./lib/SDL2_image-2.6.3-mingw/i686-w64-mingw32/lib                       `
  -L./lib/SDL2_mixer-2.6.3-mingw/i686-w64-mingw32/lib                       `
  -L./lib/SDL2_ttf-2.20.2-mingw/i686-w64-mingw32/lib                        `
                                                                            `
  -lmingw32                                                                 `
  -mwindows                                                                 `
                                                                            `
  -lSDL2main                                                                `
  -lSDL2                                                                    `
  -lSDL2_mixer                                                              `
  -lSDL2_ttf                                                                `
  -lSDL2_image                                                              `
                                                                            `
  -DGAME_VERSION="`"${GAME_VERSION}`""                                      `
  -o cosmic-intruders                                                       `
  ;

##------------------------------------------------------------------------------
Copy-Item (Get-ChildItem -Path ./lib/SDL2-devel-2.26.5-mingw/i686-w64-mingw32/  -Filter *.dll -Recurse -ErrorAction SilentlyContinue -Force) $OUTPUT_DIR_PATH
Copy-Item (Get-ChildItem -Path ./lib/SDL2_image-2.6.3-mingw/i686-w64-mingw32/   -Filter *.dll -Recurse -ErrorAction SilentlyContinue -Force) $OUTPUT_DIR_PATH
Copy-Item (Get-ChildItem -Path ./lib/SDL2_mixer-2.6.3-mingw/i686-w64-mingw32/   -Filter *.dll -Recurse -ErrorAction SilentlyContinue -Force) $OUTPUT_DIR_PATH
Copy-Item (Get-ChildItem -Path ./lib/SDL2_ttf-2.20.2-mingw/i686-w64-mingw32/    -Filter *.dll -Recurse -ErrorAction SilentlyContinue -Force) $OUTPUT_DIR_PATH
Copy-Item ./lib/libgcc_s_dw2-1.dll $OUTPUT_DIR_PATH
Copy-Item ./lib/libstdc++-6.dll    $OUTPUT_DIR_PATH

Move-Item ./cosmic-intruders.exe   $OUTPUT_DIR_PATH
