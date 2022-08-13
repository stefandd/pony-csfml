// 
// The SFML object as presented by CSFML
// 
struct _Vertex
    embed position:  _Vector2f
    embed color:     _Color
    embed texCoords: _Vector2f

    new create(position': Vector2f, color': Color, texCoords': Vector2f = Vector2f(0,0)) =>
      position  = _Vector2f.copy(position'._getStruct())
      color     = _Color.copy(color'._getStruct())
      texCoords = _Vector2f.copy(texCoords'._getStruct())

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class Vertex
    var _csfml: _Vertex

    new create(position: Vector2f, color: Color, texCoords: Vector2f = Vector2f(0,0)) =>
      _csfml = _Vertex(position, color, texCoords)

    new _from_csfml(v: _Vertex) =>
      _csfml = v

    fun ref _set_csfml(v: _Vertex): Vertex =>
      _csfml = v
      this

    fun ref getPosition(using: Optional[Vector2f] = None): Vector2f =>
      """
        Extends the SFML method by allowing an optional Vector2f to be
        provided. If provided, it will be "recycled" by the method to become
        the return value, avoiding the allocation of a new object.
      """
      match using
      | None => Vector2f._from_csfml(_csfml.position)
      | let x: Vector2f => x._set_csfml(_csfml.position)
      end

    fun ref getColor(using: Optional[Color] = None): Color =>
      """
        Extends the SFML method by allowing an optional Color to be
        provided. If provided, it will be "recycled" by the method to become
        the return value, avoiding the allocation of a new object.
      """
      match using
      | None => Color._from_csfml(_csfml.color)
      | let x: Color => x._set_csfml(_csfml.color)
      end  

    fun ref getTexCoords(using: Optional[Vector2f] = None): Vector2f =>
      """
        Extends the SFML method by allowing an optional Vector2f to be
        provided. If provided, it will be "recycled" by the method to become
        the return value, avoiding the allocation of a new object.
      """
      match using
      | None => Vector2f._from_csfml(_csfml.texCoords)
      | let x: Vector2f => x._set_csfml(_csfml.texCoords)
      end

    //fun ref _getStruct(): _Vertex => _csfml