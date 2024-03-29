//
// FFI declarations for CSFML functions
//
use @sfVertexArray_create[NullablePointer[_VertexArray]]()
use @sfVertexArray_copy[NullablePointer[_VertexArray]](vtxArr: _VertexArray box)
use @sfVertexArray_destroy[None](vtxArr: _VertexArray box)
use @sfVertexArray_getVertexCount[USize](vtxArr: _VertexArray box)
use @sfVertexArray_getVertex[_Vertex](vtxArr: _VertexArray box, index: USize)
use @sfVertexArray_clear[None](vtxArr: _VertexArray box)
use @sfVertexArray_resize[None](vtxArr: _VertexArray box, vertexCount: USize)
use @sfVertexArray_appendA[None](vtxArr: _VertexArray box, pos: U64, color: U32, tex: U64)
use @sfVertexArray_setPrimitiveType[None](vtxArr: _VertexArray box, primitiveType: I32)
use @sfVertexArray_getPrimitiveType[I32](vtxArr: _VertexArray box)
use @sfVertexArray_getBoundsA[None](vtxArr: _VertexArray box, bounds: _FloatRect)

use "debug"

//
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _VertexArray

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class VertexArray

  var _csfml: _VertexArray

  new create()? =>
    _csfml = @sfVertexArray_create()()?

  new copy(va: VertexArray)? =>
    _csfml = @sfVertexArray_copy(va._csfml)()?

  fun getVertexCount(): USize =>
    @sfVertexArray_getVertexCount(_csfml)

  fun getVertex(index: USize, using: Optional[Vertex] = None): Vertex ref ? =>
    """
      Extends the SFML method by allowing an optional Vertex to be
      provided. If provided, it will be "recycled" by the method to become
      the return value, avoiding the allocation of a new object.
    """
    if index >= getVertexCount() then
      Debug("getVertex, index = " + index.string() + " is out of range. There are " + (getVertexCount()-1).string() + " vertices.")
      error
    end
    let vtxptr = @sfVertexArray_getVertex(_csfml, index)
    match using
    | None => Vertex._fromCsfml(vtxptr)
    | let v: Vertex => v._setCsfml(vtxptr)
    end

  fun ref clear() =>
    @sfVertexArray_clear(_csfml)

  fun ref resize(vertexCount: USize) =>
    @sfVertexArray_resize(_csfml, vertexCount)

  fun ref append(v: Vertex) =>
    @sfVertexArray_appendA(
      _csfml,
      v.getPosition()._u64(),
      v.getColor()._u32(),
      v.getTexCoords()._u64() )

  fun ref setPrimitiveType(pt: PrimitiveType) =>
    @sfVertexArray_setPrimitiveType(_csfml, pt())

  fun ref getPrimitiveType(): I32 =>
    @sfVertexArray_getPrimitiveType(_csfml)

  fun getBounds(): FloatRect =>
    let rect = FloatRect(0, 0, 0, 0)
    @sfVertexArray_getBoundsA(_csfml, rect._getCsfml())
    rect

  fun ref _getCsfml(): _VertexArray =>
    _csfml

  fun \deprecated\ destroy() =>
      """ Because Pony has garbage collection, you don't need to call destroy() """
      None

  fun _final() =>
    @sfVertexArray_destroy(_csfml)

