use "path:../shim library/"
use "lib:csfml-main" if windows
use "lib:csfml-system"
use "lib:csfml-window"
use "lib:csfml-graphics"
use "lib:csfml-audio"
use "lib:csfmlshim"

// Sleep
use @sfSleep[None](duration: I64)

// Other
use @memcpy[Pointer[None]](dest: Pointer[None], src: Pointer[None] box, n: USize)

type Optional[X] is (X | None)
type Maybe[X] is (X | None)

primitive System
    fun sleep(duration: I64) => @sfSleep(duration)
