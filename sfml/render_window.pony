// FFI declarations for CSFML functions
//
use @sfRenderWindow_createA[_RenderWindowRaw](width: U32, height: U32, bitsPerPixel: U32, name: Pointer[U8 val] tag, style: I32, settings: _ContextSettingsRaw)
use @sfRenderWindow_createUnicodeA[_RenderWindowRaw](width: U32, height: U32, bitsPerPixel: U32, name: Pointer[U32 val] tag, style: I32, settings: _ContextSettingsRaw)
use @sfRenderWindow_setFramerateLimit[None](window: _RenderWindowRaw box, limit: U32)
use @sfRenderWindow_getSettingsA[None](window: _RenderWindowRaw box, settings: _ContextSettingsRaw)
use @sfRenderWindow_isOpen[I32](window: _RenderWindowRaw box)
use @sfRenderWindow_hasFocus[I32](window: _RenderWindowRaw box)
use @sfRenderWindow_setActive[I32](window: _RenderWindowRaw box, active: I32)
use @sfRenderWindow_clear[None](window: _RenderWindowRaw box, color: U32)
use @sfRenderWindow_display[None](window: _RenderWindowRaw box)
use @sfRenderWindow_setView[None](window: _RenderWindowRaw box, view: ViewRaw box)
use @sfRenderWindow_drawSprite[None](window: _RenderWindowRaw box, sprite: _SpriteRaw box, states: _RenderStatesRaw box)
use @sfRenderWindow_drawShape[None](window: _RenderWindowRaw box, shape: ShapeRaw box, states: _RenderStatesRaw box)
use @sfRenderWindow_drawText[None](window: _RenderWindowRaw box, text: _TextRaw box, states: _RenderStatesRaw box)
use @sfRenderWindow_drawVertexArray[None](window: _RenderWindowRaw box, vertexArray: _VertexArrayRaw box, states: _RenderStatesRaw box)
use @sfRenderWindow_pollEvent[I32](window: _RenderWindowRaw box, event: Pointer[U8] tag)
use @sfRenderWindow_getSize[U64](window: _RenderWindowRaw box)
use @sfRenderWindow_destroy[None](window: _RenderWindowRaw box)

// 
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
primitive _RenderWindow
type _RenderWindowRaw is Pointer[_RenderWindow]

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class RenderWindow
    var _raw: _RenderWindowRaw ref
    let _evt: EventStruct

    new create(mode: VideoMode box, title: String, style: I32, settings: ContextSettings = ContextSettings)? =>
        //let mode_arr: Array[U32] = [mode.width; mode.height; mode.bitsPerPixel] // trick to send this instead of the value struct
        //_raw = @sfRenderWindow_create(mode_arr.cpointer(), title.cstring(), style, ctxsettings)
        _raw = @sfRenderWindow_createA(mode.width, mode.height, mode.bitsPerPixel, title.cstring(), style, settings._getRaw())
        if _raw.is_null() then error end
        _evt = EventStruct(_raw)

    fun ref getEventStruct(): EventStruct =>
        _evt
    
    fun ref getSettings(): ContextSettings =>
        var s: ContextSettings = ContextSettings
        @sfRenderWindow_getSettingsA(_raw, s._getRaw())
        s

    fun ref setFramerateLimit(limit: U32) =>
        @sfRenderWindow_setFramerateLimit(_raw, limit)

    fun ref setActive(active: Bool): Bool =>
        if active then
            @sfRenderWindow_setActive(_raw, 1) > 0
        else
            @sfRenderWindow_setActive(_raw, 0) > 0
        end

    fun ref isOpen(): Bool =>
        @sfRenderWindow_isOpen(_raw) > 0

    fun ref hasFocus(): Bool =>
        @sfRenderWindow_hasFocus(_raw) > 0

    fun ref clear(color: Color = Color(0, 0, 0, 255)) =>
        @sfRenderWindow_clear(_raw, color._u32())

    fun ref drawSprite(sprite: Sprite, renderStates: Optional[RenderStates] = None) =>
        let render_states_raw = _ToRenderStatesRaw(renderStates)
        @sfRenderWindow_drawSprite(_raw, sprite._getRaw(), render_states_raw)

    fun ref drawShape(shape: Shape, renderStates: Optional[RenderStates] = None) =>
        let render_states_raw = _ToRenderStatesRaw(renderStates)
        match shape
        | let s: CircleShape =>
            @sfRenderWindow_drawShape(_raw, s._getRaw(), render_states_raw)
        | let s: RectangleShape =>
            @sfRenderWindow_drawShape(_raw, s._getRaw(), render_states_raw)
        end

    fun ref drawText(text: Text, renderStates: Optional[RenderStates] = None) =>
        let render_states_raw = _ToRenderStatesRaw(renderStates)
        @sfRenderWindow_drawText(_raw, text._getRaw(), render_states_raw)

    fun ref drawVertexArray(vertexArray: VertexArray, renderStates: Optional[RenderStates] = None) =>
        let render_states_raw = _ToRenderStatesRaw(renderStates)
        @sfRenderWindow_drawVertexArray(_raw, vertexArray._getRaw(), render_states_raw)

    fun ref display() =>
        @sfRenderWindow_display(_raw)

    fun ref setView(view: View) =>
        @sfRenderWindow_setView(_raw, view._getRaw())

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_null() then @sfRenderWindow_destroy(_raw) end
