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
##  File      : build-static.ps1                                              ##
##  Project   : Same Game                                                     ##
##  Date      : 2024-03-21                                                    ##
##  License   : See project's COPYING.TXT for full info.                      ##
##  Author    : mateus.digital <hello@mateus.digital>                         ##
##  Copyright : mateus.digital - 2024                                         ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##---------------------------------------------------------------------------~##

$ErrorActionPreference = "Stop"
Write-Output "==> Building Web Page...";

## -----------------------------------------------------------------------------
$OUTPUT_DIRECTORY = "./_out";

##------------------------------------------------------------------------------
Remove-Item -Recurse -Force "${OUTPUT_DIRECTORY}" -ErrorAction SilentlyContinue;
New-Item -Type Directory "${OUTPUT_DIRECTORY}" -Force;

## Our index
Copy-Item -Recurse "./html/*" "${OUTPUT_DIRECTORY}";
(Get-Content "./_out/index.html") `
    -replace "__GAME_VERSION__", "${GAME_VERSION}" `
    -replace "__GAME_BUILD__", "${GAME_BUILD}" `
| Set-Content "./_out/index.html"

## Emscripten Files
Copy-Item  "./_build/web-release/game.data" ${OUTPUT_DIRECTORY};
Copy-Item  "./_build/web-release/game.js"   ${OUTPUT_DIRECTORY};
Copy-Item  "./_build/web-release/game.wasm" ${OUTPUT_DIRECTORY};

## Distribution files.
New-Item -Type Directory  "${OUTPUT_DIRECTORY}/data";
Copy-Item "_dist/*.zip"   "${OUTPUT_DIRECTORY}/data";

Write-Output "==> done...";