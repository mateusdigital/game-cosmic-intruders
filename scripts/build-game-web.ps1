##----------------------------------------------------------------------------##
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
##  File      : build-game-web.ps1                                            ##
##  Project   : cosmic_intruders                                              ##
##  Date      : 2025-08-15                                                    ##
##  License   : See project's COPYING.TXT for full info.                      ##
##  Author    : mateus.digital <hello@mateus.digital>                         ##
##  Copyright : mateus.digital - 2025                                         ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##----------------------------------------------------------------------------##

$ErrorActionPreference = "Stop"

$cwd = (Get-Location).Path.Replace("\", "/");
$wslPath = "$(wsl wslpath $cwd)";
wsl bash -c "cd $wslPath && ./scripts/_build-game.sh --release --mac";
