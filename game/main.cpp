//~---------------------------------------------------------------------------//
//                        _      _                 _   _                      //
//                    ___| |_ __| |_ __ ___   __ _| |_| |_                    //
//                   / __| __/ _` | '_ ` _ \ / _` | __| __|                   //
//                   \__ \ || (_| | | | | | | (_| | |_| |_                    //
//                   |___/\__\__,_|_| |_| |_|\__,_|\__|\__|                   //
//                                                                            //
//  File      : main.cpp                                                      //
//  Project   : Cosmic Intruders                                              //
//  Date      : Nov 17, 2017                                                  //
//  License   : GPLv3                                                         //
//  Author    : stdmatt <stdmatt@pixelwizards.io>                             //
//  Copyright : stdmatt - 2017 - 2019                                         //
//                                                                            //
//  Description :                                                             //
//                                                                            //
//---------------------------------------------------------------------------~//

// Cooper
#include "Cooper/Cooper.h"
// CosmicIntruders
#include "Game/include/Helpers/GameUtils.h"
#include "Game/include/Helpers/SceneHelper.h"
#include "Game/include/Helpers/Storage.h"

#include <SDL.h>

//----------------------------------------------------------------------------//
// Entry Point                                                                //
//----------------------------------------------------------------------------//
int main(int argv, char** args)
{
    //
    // Window and Design Sizes.
    constexpr auto kDesignWidth  = 800;
    constexpr auto kDesignHeight = 800;

    constexpr auto kWindowWidth  = kDesignWidth  * 1.0f;
    constexpr auto kWindowHeight = kDesignHeight * 1.0f;

    //
    // Init
    Cooper::Log     ::Init();
    Cooper::Graphics::Init(
        kWindowWidth, kWindowHeight,
        kDesignWidth, kDesignHeight,
        CosmicIntruders::GameUtils::kWindowCaption
    );
    Cooper::RES     ::Init(CosmicIntruders::GameUtils::kBaseAssetsPath);
    Cooper::Input   ::Init();
    Cooper::Sound   ::Init();
    Cooper::Game    ::Init(60);

    #ifndef COOPER_DEBUG // Release Mode.
        Cooper::Log::SetLogLevel(Cooper::Log::LOG_LEVEL_NONE);
    #endif //COOPER_DEBUG

    //
    // Run game.
    CosmicIntruders::GameUtils::Init();
    CosmicIntruders::Storage  ::Init();

    CosmicIntruders::SceneHelper::GoToSplashScene();
    Cooper::Game::Instance()->Run();

    //
    // Shutdown
    Cooper::Game    ::Shutdown();
    Cooper::Input   ::Shutdown();
    Cooper::RES     ::Shutdown();
    Cooper::Graphics::Shutdown();
    Cooper::Log     ::Shutdown();

    return 0;
}
