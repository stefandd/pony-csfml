use @sfVertexArray_create[_VertexArrayRaw]()
use @sfVertexArray_copy[_VertexArrayRaw](vtxArr: _VertexArrayRaw box)
use @sfVertexArray_destroy[None](vtxArr: _VertexArrayRaw box)
use @sfVertexArray_getVertexCount[USize](vtxArr: _VertexArrayRaw box)
use @sfVertexArray_getVertex[Vertex](vtxArr: _VertexArrayRaw box, index: USize)
use @sfVertexArray_clear[None](vtxArr: _VertexArrayRaw box)
use @sfVertexArray_resize[None](vtxArr: _VertexArrayRaw box, vertexCount: USize)
use @sfVertexArray_appendA[None](vtxArr: _VertexArrayRaw box, pos: U64, color: U32, tex: U64)
use @sfVertexArray_setPrimitiveType[None](vtxArr: _VertexArrayRaw box, primitiveType: I32)
use @sfVertexArray_getPrimitiveType[I32](vtxArr: _VertexArrayRaw box)
use @sfVertexArray_getBoundsA[None](vtxArr: _VertexArrayRaw box, bounds: FloatRectRaw)

struct _VertexArray
type _VertexArrayRaw is NullablePointer[_VertexArray]

class VertexArray

  var _raw: _VertexArrayRaw

  new create() =>
    _raw = @sfVertexArray_create()

  fun copy() =>
    @sfVertexArray_copy(_raw)
  
  fun getVertexCount(): USize =>
    @sfVertexArray_getVertexCount(_raw)

  fun ref getVertex(index: USize): Vertex =>
    @sfVertexArray_getVertex(_raw, index)

  fun ref clear() =>
    @sfVertexArray_clear(_raw)

  fun ref resize(vertexCount: USize) =>
    @sfVertexArray_resize(_raw, vertexCount)

  fun ref append(v: Vertex) =>
    @sfVertexArray_appendA(_raw, v.position._u64(), v.color._u32(), v.texCoords._u64())

  fun ref setPrimitiveType(primitiveType: I32) =>
    @sfVertexArray_setPrimitiveType(_raw, primitiveType)

  fun ref getPrimitiveType(): I32 =>
    @sfVertexArray_getPrimitiveType(_raw)

  fun ref getBounds(): FloatRect =>
    let rect = FloatRect._from_u128(0)
    if not _raw.is_none() then
      @sfVertexArray_getBoundsA(_raw, FloatRectRaw(rect))
      rect
    else
      rect
    end

  fun ref _getRaw(): _VertexArrayRaw =>
    _raw

  fun \deprecated\ destroy() => 
      """ Because Pony has garbage collection, you don't need to call destroy() """
      None

  fun _final() =>
    if not _raw.is_none() then @sfVertexArray_destroy(_raw) end

