//
// FFI declarations for CSFML functions
//
use @sfRenderTexture_create[_RenderTextureRaw](width: U32, height: U32, depthBuffer: I32)
use @sfRenderTexture_clear[None](rendtex: _RenderTextureRaw box, color: U32)
use @sfRenderTexture_display[None](rendtex: _RenderTextureRaw box)
use @sfRenderTexture_drawSprite[None](rendtex: _RenderTextureRaw box, sprite: _SpriteRaw box, states: _RenderStatesRaw box)
use @sfRenderTexture_getTexture[_TextureRaw](rendtex: _RenderTextureRaw box)
use @sfRenderTexture_drawShape[None](rendtex: _RenderTextureRaw box, shape: _ShapeRaw box, states: _RenderStatesRaw box)
use @sfRenderTexture_drawText[None](rendtex: _RenderTextureRaw box, text: _TextRaw box, states: _RenderStatesRaw box)
use @sfRenderTexture_drawVertexArray[None](rendtex: _RenderTextureRaw box, vertexArray: _VertexArray box, states: _RenderStatesRaw box)
use @sfRenderTexture_destroy[None](rendtex: _RenderTextureRaw box)

// 
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _RenderTexture
type _RenderTextureRaw is NullablePointer[_RenderTexture]

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class RenderTexture
    var _raw: _RenderTextureRaw ref
    var _texture: (Texture ref | None) = None

    new create(width: U32, height: U32, depthBuffer: Bool) =>
        if depthBuffer then
            _raw = @sfRenderTexture_create(width, height, 1)
        else
            _raw = @sfRenderTexture_create(width, height, 0)
        end

    fun ref clear(color: Color) =>
        @sfRenderTexture_clear(_raw, color._u32())

    fun ref drawSprite(sprite: Sprite, renderStates: Optional[RenderStates] = None) =>
        let render_states_raw = _ToRenderStatesRaw(renderStates)
        @sfRenderTexture_drawSprite(_raw, sprite._getRaw(), render_states_raw)

    fun ref drawShape(shape: Shape, renderStates: Optional[RenderStates] = None) =>
        let render_states_raw = _ToRenderStatesRaw(renderStates)
        match shape
        | let s: CircleShape =>
            @sfRenderTexture_drawShape(_raw, s._getRaw(), render_states_raw)
        | let s: RectangleShape =>
            @sfRenderTexture_drawShape(_raw, s._getRaw(), render_states_raw)
        end

    fun ref drawText(text: Text, renderStates: Optional[RenderStates] = None) =>
        let render_states_raw = _ToRenderStatesRaw(renderStates)
        @sfRenderTexture_drawText(_raw, text._getRaw(), render_states_raw)

    fun ref drawVertexArray(vertexArray: VertexArray, renderStates: Optional[RenderStates] = None) =>
        let render_states_raw = _ToRenderStatesRaw(renderStates)
        @sfRenderTexture_drawVertexArray(_raw, vertexArray._getCsfml(), render_states_raw)

    // In SFML, the texture returned is read-only (const). 
    // In Pony, we return a `box` reference to achieve the same.
    // We want to maintain a one-to-one relationship between:
    //   1) the SFML-Texture owned by this's SFML-RenderTexture, and
    //   2) the Pony binding's abstracting Texture returned by by this method.
    // Therefore, we'll only create the Texture once and save it for future getTexture calls.
    fun ref getTexture(): Texture box =>
        match _texture
            | let existing_texture: Texture ref => 
                existing_texture
            | None => 
                let csfml_texture = @sfRenderTexture_getTexture(_raw)
                let abstracting_texture = Texture._wrap(csfml_texture)
                _texture = abstracting_texture
                abstracting_texture
        end

    fun ref display() =>
        @sfRenderTexture_display(_raw)

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfRenderTexture_destroy(_raw) end
