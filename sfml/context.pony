//
// FFI declarations for CSFML functions
//
use @sfContext_create[_Context]()
use @sfContext_destroy[None](context: _Context box)
use @sfContext_setActive[I32](context: _Context, active: I32)
use @sfContext_getSettingsA[None](context: _Context, settings: _ContextSettingsRaw)

// 
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _Context

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API
//
class Context
    let _csfml: _Context ref
    var _context_settings: ContextSettings

    new create() =>
        _csfml = @sfContext_create()
        // A.B. assumes that context settings never change, in which case I can get them here:
        _context_settings = ContextSettings
        @sfContext_getSettingsA(_csfml, _context_settings._getRaw())

    fun ref getSettings(): ContextSettings =>
        _context_settings

    fun ref setActive(active: Bool): Bool =>
        if active then
            @sfContext_setActive(_csfml, 1) > 0
        else
            @sfContext_setActive(_csfml, 0) > 0
        end

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        @sfContext_destroy(_csfml)


