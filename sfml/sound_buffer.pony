//
// FFI declarations for CSFML functions
//
use @sfSoundBuffer_createFromFile[NullablePointer[_SoundBuffer]](filename: Pointer[U8 val] tag)
use @sfSoundBuffer_destroy[None](soundBuffer: _SoundBuffer box)

//
// Because CSFML provides all the functions required to create and manipulate
// this structure (see 'use' statements, above), we don't need to define its
// fields. We'll only be working with it as a pointer.
//
struct _SoundBuffer

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class SoundBuffer
    let _buff: _SoundBuffer

    new create(file: String)? =>
        _buff = @sfSoundBuffer_createFromFile(file.cstring())()?

    fun ref _getCsfml(): _SoundBuffer =>
        _buff

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        @sfSoundBuffer_destroy(_buff)
