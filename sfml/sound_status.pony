

primitive SoundStopped fun _i32(): I32 => 0 // Sound / music is not playing
primitive SoundPaused  fun _i32(): I32 => 1 // Sound / music is paused
primitive SoundPlaying fun _i32(): I32 => 2 // Sound / music is playing

type SoundStatus is 
  ( SoundStopped
  | SoundPaused
  | SoundPlaying )


// The reverse mapping, below, *should* be a total function but this is
// not possible in Pony because it (and most other languages) don't have
// refinement types.
//
// Any failure of these reverse mappings will be due to a programming error
// that needs to be fixed, so we'll just print an error message and kill the
// process.

primitive _I32toSoundStatus
    fun apply(i32: I32): SoundStatus =>
        match i32
        | SoundStopped._i32() => SoundStopped
        | SoundPaused._i32()  => SoundPaused
        | SoundPlaying._i32() => SoundPlaying
        else
            @fprintf(@pony_os_stderr(), "ERROR: Sound.getStatus failed".cstring())
            @exit(1)
            SoundStopped // Never get here, but this satisfies the compiler's type checking.
        end
