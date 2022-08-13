use "assert"
use "debug"

//
// FFI declarations for CSFML functions
//
use @sfVertexArray_create[_VertexArrayRaw]()
use @sfVertexArray_copy[_VertexArrayRaw](vtxArr: _VertexArrayRaw box)
use @sfVertexArray_destroy[None](vtxArr: _VertexArrayRaw box)
use @sfVertexArray_getVertexCount[USize](vtxArr: _VertexArrayRaw box)
use @sfVertexArray_getVertex[_Vertex](vtxArr: _VertexArrayRaw box, index: USize)
use @sfVertexArray_clear[None](vtxArr: _VertexArrayRaw box)
use @sfVertexArray_resize[None](vtxArr: _VertexArrayRaw box, vertexCount: USize)
use @sfVertexArray_appendA[None](vtxArr: _VertexArrayRaw box, pos: U64, color: U32, tex: U64)
use @sfVertexArray_setPrimitiveType[None](vtxArr: _VertexArrayRaw box, primitiveType: I32)
use @sfVertexArray_getPrimitiveType[I32](vtxArr: _VertexArrayRaw box)
use @sfVertexArray_getBoundsA[None](vtxArr: _VertexArrayRaw box, bounds: _FloatRect)

//
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _VertexArray
type _VertexArrayRaw is NullablePointer[_VertexArray]

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class VertexArray

  var _raw: _VertexArrayRaw

  new create()? =>
    _raw = @sfVertexArray_create()
    if _raw.is_none() then error end

  new copy(va: VertexArray)? =>
    _raw = @sfVertexArray_copy(va._raw)
    if _raw.is_none() then error end

  fun getVertexCount(): USize =>
    @sfVertexArray_getVertexCount(_raw)

  fun getVertex(index: USize, using: Optional[Vertex] = None): Vertex ref =>
    """
      Extends the SFML method by allowing an optional Vertex to be
      provided. If provided, it will be "recycled" by the method to become
      the return value, avoiding the allocation of a new object.
    """
    let vtxptr = @sfVertexArray_getVertex(_raw, index)
    match using
    | None => Vertex._from_csfml(vtxptr)
    | let v: Vertex => v._set_csfml(vtxptr)
    end

  fun ref clear() =>
    @sfVertexArray_clear(_raw)

  fun ref resize(vertexCount: USize) =>
    @sfVertexArray_resize(_raw, vertexCount)

  fun ref append(v: Vertex) =>
    @sfVertexArray_appendA(
      _raw,
      v.getPosition()._u64(),
      v.getColor()._u32(),
      v.getTexCoords()._u64() )

  fun ref setPrimitiveType(pt: PrimitiveType) =>
    @sfVertexArray_setPrimitiveType(_raw, pt())

  fun ref getPrimitiveType(): I32 =>
    @sfVertexArray_getPrimitiveType(_raw)

  fun getBounds(using: Optional[FloatRect] = None): FloatRect =>
    """
      An extended version of SFML's getBounds which allows an optional 
      FloatRect to be specified. If specified, it will be recycled by this
      function and used as the return value, avoiding the allocation of a new
      FloatRect object.
    """
    let rect = 
      match using
      | None => FloatRect(0, 0, 0, 0)
      | let x: FloatRect => x
      end
    @sfVertexArray_getBoundsA(_raw, rect._getStruct())
    rect

  fun ref _getRaw(): _VertexArrayRaw =>
    _raw

  fun \deprecated\ destroy() =>
      """ Because Pony has garbage collection, you don't need to call destroy() """
      None

  fun _final() =>
    if not _raw.is_none() then @sfVertexArray_destroy(_raw) end

