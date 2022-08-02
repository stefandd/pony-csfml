use @sfContext_create[ContextRaw]()
use @sfContext_destroy[None](context: ContextRaw box)
use @sfContext_setActive[I32](context: ContextRaw, active: I32)
use @sfContext_getSettingsA[None](context: ContextRaw, settings: ContextSettingsRaw)


primitive _Context
type ContextRaw is Pointer[_Context]


class Context
    var _raw: ContextRaw ref

    new create() =>
        _raw = @sfContext_create()

    fun ref getSettings(): ContextSettings =>
        var s: ContextSettings = ContextSettings.create(0, 0, 0, 0, 0, 0, 0)
        @sfContext_getSettingsA(_raw, ContextSettingsRaw(s))
        s

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


