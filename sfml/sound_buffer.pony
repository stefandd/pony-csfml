
use @sfSoundBuffer_createFromFile[NullablePointer[_SoundBuffer]](filename: Pointer[U8 val] tag)
use @sfSoundBuffer_destroy[None](soundBuffer: _SoundBuffer box)

struct _SoundBuffer

class SoundBuffer
    var _buff: _SoundBuffer

    new create(file: String)? =>
        _buff = @sfSoundBuffer_createFromFile(file.cstring())()?

    fun ref _getCsfml(): _SoundBuffer =>
        _buff

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        @sfSoundBuffer_destroy(_buff)


