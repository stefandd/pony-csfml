use @sfVertexArray_create[SFVertexArrayRaw]()
use @sfVertexArray_copy[SFVertexArrayRaw](vtxArr: SFVertexArrayRaw box)
use @sfVertexArray_destroy[None](vtxArr: SFVertexArrayRaw box)
use @sfVertexArray_getVertexCount[USize](vtxArr: SFVertexArrayRaw box)
use @sfVertexArray_getVertex[SFVertex](vtxArr: SFVertexArrayRaw box, index: USize)
use @sfVertexArray_clear[None](vtxArr: SFVertexArrayRaw box)
use @sfVertexArray_resize[None](vtxArr: SFVertexArrayRaw box, vertexCount: USize)
use @sfVertexArray_appendA[None](vtxArr: SFVertexArrayRaw box, pos: U64, color: U32, tex: U64)
use @sfVertexArray_setPrimitiveType[None](vtxArr: SFVertexArrayRaw box, primitiveType: I32)
use @sfVertexArray_getPrimitiveType[I32](vtxArr: SFVertexArrayRaw box)
use @sfVertexArray_getBoundsA[None](vtxArr: SFVertexArrayRaw box, bounds: SFFloatRectRaw)

struct _SFVertexArray
type SFVertexArrayRaw is NullablePointer[_SFVertexArray]

class SFVertexArray

  var _raw: SFVertexArrayRaw

  new create() =>
    _raw = @sfVertexArray_create()

  fun copy() =>
    @sfVertexArray_copy(_raw)
  
  fun ref destroy() =>
    if not _raw.is_none() then
       @sfVertexArray_destroy(_raw)
      _raw = SFVertexArrayRaw.none()
    end

  fun getVertexCount(): USize =>
    @sfVertexArray_getVertexCount(_raw)

  fun ref getVertex(index: USize): SFVertex =>
    @sfVertexArray_getVertex(_raw, index)

  fun ref clear() =>
    @sfVertexArray_clear(_raw)

  fun ref resize(vertexCount: USize) =>
    @sfVertexArray_resize(_raw, vertexCount)

  fun ref append(v: SFVertex) =>
    @sfVertexArray_appendA(_raw, v.position.u64(), v.color.u32(), v.texCoords.u64())

  fun ref setPrimitiveType(primitiveType: I32) =>
    @sfVertexArray_setPrimitiveType(_raw, primitiveType)

  fun ref getPrimitiveType(): I32 =>
    @sfVertexArray_getPrimitiveType(_raw)

  fun ref getBounds(): SFFloatRect =>
    let rect = SFFloatRect.from_u128(0)
    if not _raw.is_none() then
      @sfVertexArray_getBoundsA(_raw, SFFloatRectRaw(rect))
      rect
    else
      rect
    end

  fun ref getRaw(): SFVertexArrayRaw =>
    _raw

  fun ref isNULL(): Bool =>
    _raw.is_none()

  fun _final() =>
    if not _raw.is_none() then @sfVertexArray_destroy(_raw) end

