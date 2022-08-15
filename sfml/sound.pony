//
// FFI declarations for CSFML functions
//
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

// Because CSFML provides all the functions required to create and manipulate
// this structure (see 'use' statements, above), we don't need to define its
// fields. We'll only be working with it as a pointer.
//
struct _Sound

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class Sound
    let _sound: _Sound ref

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

    fun ref getStatus(): SoundStatus =>
        _I32toSoundStatus(@sfSound_getStatus(_sound))

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
