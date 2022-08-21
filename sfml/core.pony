use @fprintf[I32](stream: Pointer[U8] tag, fmt: Pointer[U8] tag, ...)
use @pony_os_stdout[Pointer[U8]]()
use @pony_os_stderr[Pointer[U8]]()
use @exit[None](code: I32)

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

// This doesn't really help the type system, but it can help make FFI declarations more readable.
// Note that U128 is left out of the union type because it doesn't work on Linux.
type _Packed[T, U: (U8 | U16 | U32 | U64)] is U