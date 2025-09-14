
<!-- ----------------------------------------------------------------------- -->
## Hello Miniclip!

Hi there! This my application test for Software Developer (Web Client)! 
I made this game with a lot of love and I hope that you like it ;D

With love... 

[n2omatt](http://n2omatt.com)!

<!-- ----------------------------------------------------------------------- -->
## Play the game:

* Web version: [http://amazingcow.com/cosmic](http://amazingcow.com/cosmic)
* GNU/Linux: [itch.io](https://amazingcow.itch.io/cosmic)
* Sources: [github](https://github.com/AmazingCow-Game/CosmicIntruders)


<!-- ----------------------------------------------------------------------- -->
## Public of this README.

This document is targeted for more technical oriented people. So I'll make some
assumptions here about what you should know about - mainly about some language
constructs (I mean a basic C++) and some concepts of game development.

Everything else I'll try to explain more deeply, so if you're already know 
a little more feel free to skip the section - At start of each section I'll try
indicate the technical inclination of that section in a scale 0 less technical, 
to 10 more technical.


<!-- ----------------------------------------------------------------------- -->
## Project Structure. (Level: 5)

Cosmic Intruders was structured in two major parts - namely **Game** and **Cooper**.
Each part is responsible for a major section of the game, and as you might already 
get by the names, **Game** is the part that implements the gameplay of Cosmic Intruders.
But  **Cooper** isn't so obvious, so lets take this opportunity to detail each one.

### Cooper

This is the _engine_ that **Game** uses to implement the gameplay itself. It was
written specifically for this project, but not restrict to it. While is true that
it has some weak points, it will be continued to be developed furthermore on 
the future.

So in short, **Cooper** was created to abstract the underlying platform and 
make some cumbersome and repetitive  tasks in game development easier.

### Game

This part implements the actual gameplay of Cosmic Intruders. It uses **Cooper**
to avoid some tedious tasks and make the code more main tabled and easy to modify.


<!-- ----------------------------------------------------------------------- -->
## Project Files Structure. (Level: 8)

The project is structure the following way on the filesystem:

* game - Directory with the source files of **Game**, the gameplay part.
* libs
    * Cooper - The **Cooper** source files
* assets - Directory that contain all assets directories.
  * Atlases - The custom _textures atlases_ used by the game.
  * Fonts - The _True-Type_ files used by the game.
  * Sounds - The audio files used by the game.
  * Textures - The textures files used by the game.
* resources - Things that are needed for packaging the game.
* cmake - The _find_ files used by _cmake_ to find the libraries.   
Taken from: https://github.com/tcbrindle/sdl2-cmake-scripts
* scripts - Numerous helper scripts to ease the building.


<!-- ----------------------------------------------------------------------- -->
## Building from source (Level: 10)

We use two differently ways to build the game for each supported platform.
In any case the build scripts used to platform the actual building is located
in ```./path/to/project/scripts```.

To build you can use the ```build.sh```, use ```cmake``` or build with
[Clion](https://www.jetbrains.com/clion/). Each and every build possibility is
actually using ```cmake``` underneaths.


#### Using ```build.sh```:
 
1. Change the directory: Ex: ```cd ./path/to/project/scripts```
2. Run ```build.sh``` with the desired options.  Ex: 
```./build.sh -m=release -t=gnu_linux```

All debug builds where using **CXX** ```-g``` and all release builds are using
```-DNDEBUG and -O3```.


#### Using ```cmake.sh```:

Just... 

```
mkdir build && cd build
cmake ../cmake/
make
```


### Using Rider:

Open the root directory of the game and you should be good to go. Next define
a build target in ```Run -> Edit Configurations``` and build the project in
```Run -> Build```.


<!-- ----------------------------------------------------------------------- -->
## Project dependencies: (Level: 5)

Cosmic Intruders depends of: 

* [SDL2 - Simple DirectMedia Layer](https://libsdl.org).
* [SDL2_image](https://www.libsdl.org/projects/SDL_image/).
* [SDL2_ttf](https://www.libsdl.org/projects/SDL_ttf/).
* [Cooper](https://github.com/AmazingCow-Game-Framework/Cooper) - The engine.
* [Emscripten](http://kripken.github.io/emscripten-site/) - For the web builds.



### Installing dependencies: (Level 10)

**SDL2**, **SDL2_image** and **SDL2_ttf** - On Debian-based systems you just
need to:

```sudo apt-get install  libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev```

On other platforms please refer to the official [SDL documentation](https://wiki.libsdl.org/Installation).


**Cooper**  - We use the [Cooper](https://github.com/AmazingCow-Game-Framework/Cooper)
git repository as as submodule. So all that you need to do is initialize it.

``` git submodule update --init --recursive ``` on the project root directory.

**Emscripten** - Used to build the project to the web.  
To install it in your platform please refer to the 
[official documentation](http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html).


<!-- ----------------------------------------------------------------------- -->

## Cooper (Level 2)

I tried to make **Cooper** more reusable and easier to extent as possible in 
the period that I had to make it. I had to balance the time that I had in
make the **Game** and make the structure to make it better. Since I'm applying 
to a role that's isn't gameplay per se I thought that you might be interested
in this part of the game development too. 

In the **Cooper** I tried to show my concerns in _memory management_  with _smart pointers_
and custom deleters in ```std::shared_ptr```. I tried to make a point that I really 
think that a good usage of MACROS can increases code readability.

Cooper is named after:   
<a href="http://interstellarfilm.wikia.com/wiki/Joseph_Cooper">
    <img src="https://maylicious1026.files.wordpress.com/2014/11/interstellar-film-still-cooper-daughter.jpg" 
        width="35%" 
        height="35%">
</a>


### Components:

* **Game** - Responsible by the game routines, timing and non visible entities.
* **Graphics**  - Responsible for the graphics routines and entities that are 
visible on the screen.
* **Input** -  Responsible by the input (Currently only Mouse and Keyboard).
* **Log** - Responsible by the logging facilities of the engine.
* **RES** - Responsible by the resources management on the game.
* **Sound** - Responsible to play sounds in the game.

### Strong Points:

* Pretty reusable and easy to maintain implementation.
* Very readable code with a lot of comments, symmetry and good practices.
* A nice usage of ```constexpr```, **RAII** and _smart pointers_.
* Good modularization.  
* A LOT of helper things to make the code sweeter! I read sometime ago in a 
book that I can't remember now _"...syntactic sugar makes the language sweeter..."_, 
so I made a lot of nice constructs to make the game development sweeter and funnier.
* Safe programming with a lot of assertions.
* Good use of C++ with _forward declarations_, _smart pointers_, _ranged fors_, 
  ```const``` correctness.

### Weak Points:

* Lack of a good transforming system. I started thinking in make a very thin
layer on SDL but changed my mind aft wards, so one thing that I left behind was 
the transforming system. Today it is very messy and hard to maintain and understand.
So it does the job for the Cosmic Intruders project but is lacking for other type
of games.

* Not using SDL2_mixer library. Due the short time of project added up that I
hadn't full time to work on it, forced me make some concessions. One of them was
not mess with the _SDL2_mixer + Emscripten_ integration and went to a easier 
solution. While the [library](https://github.com/jakebesworth/Simple-SDL2-Audio)
that I used does a pretty good job, I would had more fun rolling a implementation
myself.

* Lack of doxygen comments - I love them, but simply hadn't time :`/

* I made somethings that weren't end to be used in the game itself. While surely
I'll make a good use of them in the next games for this project it was a loss.


<!-- ----------------------------------------------------------------------- -->
## Game: (Level 2)

Well, in game I tried to show some points on project structuralization, some C++ 
_good usages_ like _forward declarations_ instead of ```#include```s to 
speed up the compilation. While the gameplay itself isn't too complicated 
and surely could be implemented in a much more simpler way, I took the opportunity 
to _over-engineer_ it to make a room to show some things as I said above.  So 
to let it crystal clear - The project is over engineered **by a purpose** :D I don't 
think that it needs that complexity to be done. 

### Strong Points:

* Good readability with a lot of comments.
* Good structure with a lot of responsibilities of concerns. 
* Use of ```constexpr``` values to make the _magic numbers_ disappear.
* Good use of C++ with _forward declarations_, _smart pointers_, _ranged fors_.

### Weak Points:

* Code is more complex that needs to be - But like I said, I did it on purpose
to make a point of some good things mentioned above.
* Collision detection on shields could be improved to be a lot faster.
* I hadn't a copy of the original game to play, so I need to just watch videos
on the youtube and play cloned version of it. This makes the values don't 
be accurate enough to be a precise clone, nevertheless to implement such a game
by heart I think that it's close enough.


<!-- ----------------------------------------------------------------------- -->
## Final words....

I really want to thank you for spare some time to read this. I hope that you 
enjoyed and made a quite nice time thought the reading!

Mommy and my wife were very very kind with me on this week! I think that 
everybody needs to know it! I wouldn't be able without them <3

I really, really would **enjoy** join you and be part of Miniclip and I really
hope that you liked what you seen here - I'm have a lot more to share, learn, 
teach and do, would be wonderful do all of this with you.

In any case, positive or negative doesn't matter, I'll more than happy to 
receive feedback about the project. This will help me improve my flaws and 
strengths and grow with them! **So please send me feedback!**

Thank you!
