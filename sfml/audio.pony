
use @sfSoundBuffer_createFromFile[SFSoundBufferRaw](filename: Pointer[U8 val] tag)
use @sfSoundBuffer_destroy[None](soundBuffer : SFSoundBufferRaw box)

use @sfSound_create[SFSoundRaw]()
use @sfSound_setBuffer[None](sound : SFSoundRaw box, buffer : SFSoundBufferRaw box)
use @sfSound_play[None](sound : SFSoundRaw box)
use @sfSound_stop[None](sound : SFSoundRaw box)
use @sfSound_pause[None](sound : SFSoundRaw box)
use @sfSound_setPitch[None](sound : SFSoundRaw box, pitch : F32)
use @sfSound_setVolume[None](sound : SFSoundRaw box, volume : F32)
use @sfSound_setLoop[None](sound : SFSoundRaw box, loop : I32)
use @sfSound_getStatus[I32](sound : SFSoundRaw box)
use @sfSound_destroy[None](sound : SFSoundRaw box)

primitive SFSoundStatus
    fun sfStopped() : I32 => 0 ///< Sound / music is not playing
    fun sfPaused() : I32 =>  1 ///< Sound / music is paused
    fun sfPlaying() : I32 => 2 ///< Sound / music is playing

struct _SFSoundBuffer
type SFSoundBufferRaw is NullablePointer[_SFSoundBuffer]

class SFSoundBuffer
    var _raw : SFSoundBufferRaw

    new create(file : String) =>
        _raw = @sfSoundBuffer_createFromFile(file.cstring())

    fun ref getRaw() : SFSoundBufferRaw =>
        _raw

    fun ref isNULL() : Bool =>
        _raw.is_none()

    fun ref destroy() =>
        if not _raw.is_none() then
             @sfSoundBuffer_destroy(_raw)
            _raw = SFSoundBufferRaw.none()
        end

    fun _final() =>
        if not _raw.is_none() then @sfSoundBuffer_destroy(_raw) end

struct _SFSound
type SFSoundRaw is NullablePointer[_SFSound]

class SFSound
    var _raw : SFSoundRaw

    new create() =>
        _raw = @sfSound_create()

    new fromBuffer(buffer : SFSoundBuffer) =>
        _raw = @sfSound_create()
        @sfSound_setBuffer(_raw, buffer.getRaw())

    fun ref setBuffer(buffer : SFSoundBuffer) =>
        @sfSound_setBuffer(_raw, buffer.getRaw())

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

    fun ref getRaw() : SFSoundRaw =>
        _raw

    fun ref isNULL() : Bool =>
        _raw.is_none()

    fun ref destroy() =>
        if not _raw.is_none() then
             @sfSound_destroy(_raw)
            _raw = SFSoundRaw.none()
        end

    fun _final() =>
        if not _raw.is_none() then @sfSound_destroy(_raw) end
