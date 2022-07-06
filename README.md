## What is this?

A small wrapper for CSFML in `Pony`. I just wrapped enough of the vast functionality to be able to write small games with sound.

There is a small test app, `test.pony`, that shows random pixel noise. While SFML can be multithreaded, its own threading system and that of Pony are likely not compatible. Thus, the Pony actor that renders to SFML must then be proofed against its rendering context being accessed from multiple (Pony) threads. The simplest way would be to prevent Pony from using more than 1 core/1 scheduler thread by adding

```pony
actor Main
	..

    fun @runtime_override_defaults(rto: RuntimeOptions) =>
        rto.ponymaxthreads = 1
```

## Installation

Simply copy the `sfml` folder into the directory of your app. The test app uses `use "sfml"` so it expects the sfml folder to be in its folder. Alternatively, put the `sfml` folder whereever you keep your addon modules and adjust the `use` statement.
You will need the link and runtime libraries for CSFML. For Windows, those are included in the `windows libs` folder. If you are on a different system, use the dynamic link library version of CSFML and modify the section:

```pony
use "lib:csfml-main" if windows
use "lib:csfml-system"
use "lib:csfml-window"
use "lib:csfml-graphics"
use "lib:csfml-audio"
use "lib:csfmlshim"
```

in `core.pony` to point Pony to the appropriate paths.

Furthermore, from the last use entry you can see that you will also need to build a shim lib that deals with the fact that Pony does (not yet) support struct values in FFI function calls. Therefore, the shim lib has simple wrapper functions with argument lists modified such that instead of a struct value, these functions accept a struct pointer. The C source code of the shim library is included in the folder `shim library`. Compile this to produce a linkable library (ie. csfmlshim.lib or csfmlshim.a). For Windows x86_64 the lib is included in the `windows libs` folder.

If all goes well, running the test app should produce something like:
<img src="https://github.com/stefandd/ponystuff/blob/main/sfmlwrapper/screenshot.png" width="653" height="340">
