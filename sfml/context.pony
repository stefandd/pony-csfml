//
// FFI declarations for CSFML functions
//
use @sfContext_create[_ContextRaw]()
use @sfContext_destroy[None](context: _ContextRaw box)
use @sfContext_setActive[I32](context: _ContextRaw, active: I32)
use @sfContext_getSettingsA[None](context: _ContextRaw, settings: _ContextSettingsRaw)

// 
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
primitive _Context
type _ContextRaw is Pointer[_Context]

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API
//
class Context
    let _raw: _ContextRaw ref
    var _context_settings: ContextSettings

    new create() =>
        _raw = @sfContext_create()
        // A.B. assumes that context settings never change, in which case I can get them here:
        _context_settings = ContextSettings
        @sfContext_getSettingsA(_raw, _context_settings._getRaw())

    fun ref getSettings(): ContextSettings =>
        _context_settings

    fun ref setActive(active: Bool): Bool =>
        if active then
            @sfContext_setActive(_raw, 1) > 0
        else
            @sfContext_setActive(_raw, 0) > 0
        end

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_null() then @sfContext_destroy(_raw) end


