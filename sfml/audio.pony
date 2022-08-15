
use @sfSoundBuffer_createFromFile[NullablePointer[_SoundBuffer]](filename: Pointer[U8 val] tag)
use @sfSoundBuffer_destroy[None](soundBuffer: _SoundBuffer box)

use @sfSound_create[NullablePointer[_Sound]]()
use @sfSound_setBuffer[None](sound: _Sound box, buffer: _SoundBuffer box)
use @sfSound_play[None](sound: _Sound box)
use @sfSound_stop[None](sound: _Sound box)
use @sfSound_pause[None](sound: _Sound box)
use @sfSound_setPitch[None](sound: _Sound box, pitch: F32)
use @sfSound_setVolume[None](sound: _Sound box, volume: F32)
use @sfSound_setLoop[None](sound: _Sound box, loop: I32)
use @sfSound_getStatus[I32](sound: _Sound box)
use @sfSound_destroy[None](sound: _Sound box)

primitive SoundStatus
    fun sfStopped(): I32 => 0 ///< Sound / music is not playing
    fun sfPaused(): I32 =>  1 ///< Sound / music is paused
    fun sfPlaying(): I32 => 2 ///< Sound / music is playing

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



struct _Sound

class Sound
    var _sound: _Sound

    new create()? =>
        _sound = @sfSound_create()()?

    new fromBuffer(buffer: SoundBuffer)? =>
        _sound = @sfSound_create()()?
        @sfSound_setBuffer(_sound, buffer._getCsfml())

    fun ref setBuffer(buffer: SoundBuffer) =>
        @sfSound_setBuffer(_sound, buffer._getCsfml())

    fun ref play() =>
        @sfSound_play(_sound)
 
    fun ref stop() =>
        @sfSound_stop(_sound)

    fun ref pause() =>
        @sfSound_pause(_sound)

    fun ref getStatus(): I32 =>
        @sfSound_getStatus(_sound)

    fun ref setLoop(loop: Bool) =>
        if loop then
            @sfSound_setLoop(_sound, 1)
        else
            @sfSound_setLoop(_sound, 0)
        end

    fun ref setPitch(pitch: F32) =>
        @sfSound_setPitch(_sound, pitch)

    fun ref setVolume(volume: F32) =>
        @sfSound_setVolume(_sound, volume)

    fun ref _getCsfml(): _Sound =>
        _sound

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        @sfSound_destroy(_sound)
