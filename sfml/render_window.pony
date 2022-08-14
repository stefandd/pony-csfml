// FFI declarations for CSFML functions
//
use @sfRenderWindow_createA[NullablePointer[_RenderWindow]](width: U32, height: U32, bitsPerPixel: U32, name: Pointer[U8 val] tag, style: I32, settings: _ContextSettingsRaw)
use @sfRenderWindow_createUnicodeA[NullablePointer[_RenderWindow]](width: U32, height: U32, bitsPerPixel: U32, name: Pointer[U32 val] tag, style: I32, settings: _ContextSettingsRaw)
use @sfRenderWindow_setFramerateLimit[None](window: _RenderWindow box, limit: U32)
use @sfRenderWindow_getSettingsA[None](window: _RenderWindow box, settings: _ContextSettingsRaw)
use @sfRenderWindow_isOpen[I32](window: _RenderWindow box)
use @sfRenderWindow_hasFocus[I32](window: _RenderWindow box)
use @sfRenderWindow_setActive[I32](window: _RenderWindow box, active: I32)
use @sfRenderWindow_clear[None](window: _RenderWindow box, color: U32)
use @sfRenderWindow_display[None](window: _RenderWindow box)
use @sfRenderWindow_setView[None](window: _RenderWindow box, view: _ViewRaw box)
use @sfRenderWindow_drawSprite[None](window: _RenderWindow box, sprite: _SpriteRaw box, states: NullablePointer[_RenderStates] box)
use @sfRenderWindow_drawShape[None](window: _RenderWindow box, shape: _ShapeRaw box, states: NullablePointer[_RenderStates] box)
use @sfRenderWindow_drawText[None](window: _RenderWindow box, text: _TextRaw box, states: NullablePointer[_RenderStates] box)
use @sfRenderWindow_drawVertexArray[None](window: _RenderWindow box, vertexArray: _VertexArray box, states: NullablePointer[_RenderStates] box)
use @sfRenderWindow_pollEvent[I32](window: _RenderWindow box, event: Pointer[U8] tag)
use @sfRenderWindow_getSize[U64](window: _RenderWindow box)
use @sfRenderWindow_destroy[None](window: _RenderWindow box)

// 
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _RenderWindow

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class RenderWindow
    var _csfml: _RenderWindow ref
    let _evt: EventStruct

    new create(mode: VideoMode box, title: String, style: I32, settings: ContextSettings = ContextSettings)? =>
        //let mode_arr: Array[U32] = [mode.width; mode.height; mode.bitsPerPixel] // trick to send this instead of the value struct
        //_csfml = @sfRenderWindow_create(mode_arr.cpointer(), title.cstring(), style, ctxsettings)
        _csfml = 
            @sfRenderWindow_createA(
                mode.width, mode.height, mode.bitsPerPixel, 
                title.cstring(), style, settings._getRaw())()?
        _evt = EventStruct(_csfml)

    fun ref getEventStruct(): EventStruct =>
        _evt
    
    fun ref getSettings(): ContextSettings =>
        var s: ContextSettings = ContextSettings
        @sfRenderWindow_getSettingsA(_csfml, s._getRaw())
        s

    fun ref setFramerateLimit(limit: U32) =>
        @sfRenderWindow_setFramerateLimit(_csfml, limit)

    fun ref setActive(active: Bool): Bool =>
        if active then
            @sfRenderWindow_setActive(_csfml, 1) > 0
        else
            @sfRenderWindow_setActive(_csfml, 0) > 0
        end

    fun ref isOpen(): Bool =>
        @sfRenderWindow_isOpen(_csfml) > 0

    fun ref hasFocus(): Bool =>
        @sfRenderWindow_hasFocus(_csfml) > 0

    fun ref clear(color: Color = Color(0, 0, 0, 255)) =>
        @sfRenderWindow_clear(_csfml, color._u32())

    fun ref drawSprite(sprite: Sprite, renderStates: Optional[RenderStates] = None) =>
        let nullable_rs = _ToNullableRenderStates(renderStates)
        @sfRenderWindow_drawSprite(_csfml, sprite._getRaw(), nullable_rs)

    fun ref drawShape(shape: Shape, renderStates: Optional[RenderStates] = None) =>
        let render_states_csfml = _ToNullableRenderStates(renderStates)
        match shape
        | let s: CircleShape =>
            @sfRenderWindow_drawShape(_csfml, s._getRaw(), render_states_csfml)
        | let s: RectangleShape =>
            @sfRenderWindow_drawShape(_csfml, s._getRaw(), render_states_csfml)
        end

    fun ref drawText(text: Text, renderStates: Optional[RenderStates] = None) =>
        let render_states_csfml = _ToNullableRenderStates(renderStates)
        @sfRenderWindow_drawText(_csfml, text._getRaw(), render_states_csfml)

    fun ref drawVertexArray(vertexArray: VertexArray, renderStates: Optional[RenderStates] = None) =>
        let render_states_csfml = _ToNullableRenderStates(renderStates)
        @sfRenderWindow_drawVertexArray(_csfml, vertexArray._getCsfml(), render_states_csfml)

    fun ref display() =>
        @sfRenderWindow_display(_csfml)

    fun ref setView(view: View) =>
        @sfRenderWindow_setView(_csfml, view._getRaw())

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        @sfRenderWindow_destroy(_csfml)
