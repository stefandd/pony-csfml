//
// FFI declarations for CSFML functions
//
use @sfRenderTexture_create[NullablePointer[_RenderTexture]](width: U32, height: U32, depthBuffer: I32)
use @sfRenderTexture_clear[None](rendtex: _RenderTexture box, color: U32)
use @sfRenderTexture_display[None](rendtex: _RenderTexture box)
use @sfRenderTexture_drawSprite[None](rendtex: _RenderTexture box, sprite: _Sprite box, states: _RenderStates box)
use @sfRenderTexture_getTexture[_Texture](rendtex: _RenderTexture box)
use @sfRenderTexture_drawShape[None](rendtex: _RenderTexture box, shape: _Shape box, states: _RenderStates box)
use @sfRenderTexture_drawText[None](rendtex: _RenderTexture box, text: _Text box, states: _RenderStates box)
use @sfRenderTexture_drawVertexArray[None](rendtex: _RenderTexture box, vertexArray: _VertexArray box, states: _RenderStates box)
use @sfRenderTexture_destroy[None](rendtex: _RenderTexture box)

// 
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _RenderTexture

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class RenderTexture
    var _csfml: _RenderTexture ref
    var _this_created_csfml: Bool

    new create(width: U32, height: U32, depthBuffer: Bool = false)? =>
        let db: I32 = if depthBuffer then 1 else 0 end
        _csfml = @sfRenderTexture_create(width, height, db)()?
        _this_created_csfml = true

    fun ref clear(color: Color) =>
        @sfRenderTexture_clear(_csfml, color._u32())

    fun ref drawSprite(sprite: Sprite, states: RenderStates = RenderStates.default()) =>
        @sfRenderTexture_drawSprite(_csfml, sprite._getCsfml(), states._getCsfml())

    fun ref drawShape(shape: Shape, states: RenderStates = RenderStates.default()) =>
        match shape
        | let c: CircleShape =>
            @sfRenderTexture_drawShape(_csfml, c._getCsfml(), states._getCsfml())
        | let r: RectangleShape =>
            @sfRenderTexture_drawShape(_csfml, r._getCsfml(), states._getCsfml())
        end

    fun ref drawText(text: Text, states: RenderStates = RenderStates.default()) =>
        @sfRenderTexture_drawText(_csfml, text._getCsfml(), states._getCsfml())

    fun ref drawVertexArray(vertexArray: VertexArray, states: RenderStates = RenderStates.default()) =>
        @sfRenderTexture_drawVertexArray(_csfml, vertexArray._getCsfml(), states._getCsfml())

    // In SFML, the texture returned is read-only (const). 
    // In Pony, we return a `box` reference to achieve the same.
    fun ref getTexture(): Texture box =>
        let texture_csfml = @sfRenderTexture_getTexture(_csfml)
        Texture._fromCsfml(texture_csfml)

    fun ref display() =>
        @sfRenderTexture_display(_csfml)

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if _this_created_csfml then @sfRenderTexture_destroy(_csfml) end
