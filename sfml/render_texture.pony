// FFI declarations for CSFML functions
//
use @sfRenderTexture_create[RenderTextureRaw](width: U32, height: U32, depthBuffer: I32)
use @sfRenderTexture_clear[None](rendtex: RenderTextureRaw box, color: U32)
use @sfRenderTexture_display[None](rendtex: RenderTextureRaw box)
use @sfRenderTexture_drawSprite[None](rendtex: RenderTextureRaw box, sprite: _SpriteRaw box, states: _RenderStatesRaw box)
use @sfRenderTexture_getTexture[_TextureRaw](rendtex: RenderTextureRaw box)
use @sfRenderTexture_drawShape[None](rendtex: RenderTextureRaw box, shape: ShapeRaw box, states: _RenderStatesRaw box)
use @sfRenderTexture_drawText[None](rendtex: RenderTextureRaw box, text: _TextRaw box, states: _RenderStatesRaw box)
use @sfRenderTexture_drawVertexArray[None](rendtex: RenderTextureRaw box, vertexArray: _VertexArrayRaw box, states: _RenderStatesRaw box)
use @sfRenderTexture_destroy[None](rendtex: RenderTextureRaw box)


// Because CSFML provides all the functions required to create and manipulate
// this structure (see 'use' statements, above), we don't need to define its
// fields. We'll only be working with it as a pointer.
//
struct _RenderTexture
type RenderTextureRaw is NullablePointer[_RenderTexture]


// Pony Proxy Class
//
// The goal for this class to be a Pony proxy for the corresponding SFML 
// C++ class. As far as is possible (given the differences between Pony
// and C++) this class should be identical to the corresponding C++ class.
// This will make it easy for users of pony-sfml to understand existing
// SFML docs and examples.
//
// This class must not publicly expose any FFI types.
//
class RenderTexture
    var _raw: RenderTextureRaw ref
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
        @sfRenderTexture_drawVertexArray(_raw, vertexArray._getRaw(), render_states_raw)

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
