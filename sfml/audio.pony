
use @sfSoundBuffer_createFromFile[SoundBufferRaw](filename: Pointer[U8 val] tag)
use @sfSoundBuffer_destroy[None](soundBuffer : SoundBufferRaw box)

use @sfSound_create[SoundRaw]()
use @sfSound_setBuffer[None](sound : SoundRaw box, buffer : SoundBufferRaw box)
use @sfSound_play[None](sound : SoundRaw box)
use @sfSound_stop[None](sound : SoundRaw box)
use @sfSound_pause[None](sound : SoundRaw box)
use @sfSound_setPitch[None](sound : SoundRaw box, pitch : F32)
use @sfSound_setVolume[None](sound : SoundRaw box, volume : F32)
use @sfSound_setLoop[None](sound : SoundRaw box, loop : I32)
use @sfSound_getStatus[I32](sound : SoundRaw box)
use @sfSound_destroy[None](sound : SoundRaw box)

primitive SoundStatus
    fun sfStopped() : I32 => 0 ///< Sound / music is not playing
    fun sfPaused() : I32 =>  1 ///< Sound / music is paused
    fun sfPlaying() : I32 => 2 ///< Sound / music is playing

struct _SoundBuffer
type SoundBufferRaw is NullablePointer[_SoundBuffer]

class SoundBuffer
    var _raw : SoundBufferRaw

    new create(file : String) =>
        _raw = @sfSoundBuffer_createFromFile(file.cstring())

    fun ref _getRaw(): SoundBufferRaw =>
        _raw

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfSoundBuffer_destroy(_raw) end

struct _Sound
type SoundRaw is NullablePointer[_Sound]

class Sound
    var _raw : SoundRaw

    new create() =>
        _raw = @sfSound_create()

    new fromBuffer(buffer : SoundBuffer) =>
        _raw = @sfSound_create()
        @sfSound_setBuffer(_raw, buffer._getRaw())

    fun ref setBuffer(buffer : SoundBuffer) =>
        @sfSound_setBuffer(_raw, buffer._getRaw())

    fun ref play() =>
        @sfSound_play(_raw)
 
    fun ref stop() =>
        @sfSound_stop(_raw)

    fun ref pause() =>
        @sfSound_pause(_raw)

    fun ref getStatus() : I32 =>
        @sfSound_getStatus(_raw)

    fun ref setLoop(loop : Bool) =>
        if loop then
            @sfSound_setLoop(_raw, 1)
        else
            @sfSound_setLoop(_raw, 0)
        end

    fun ref setPitch(pitch : F32) =>
        @sfSound_setPitch(_raw, pitch)

    fun ref setVolume(volume : F32) =>
        @sfSound_setVolume(_raw, volume)

    fun ref _getRaw(): SoundRaw =>
        _raw

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfSound_destroy(_raw) end
