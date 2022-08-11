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

    fun ref getPosition(reuse': Optional[Vector2f]=None): Vector2f =>
      match reuse'
      | None => Vector2f._from_csfml(_csfml.position)
      | let reuse: Vector2f => reuse._set_csfml(_csfml.position)
      end

    fun ref getColor(reuse': Optional[Color]=None): Color =>
      match reuse'
      | None => Color._from_csfml(_csfml.color)
      | let reuse: Color => reuse._set_csfml(_csfml.color)
      end  

    fun ref getTexCoords(reuse': Optional[Vector2f]=None): Vector2f =>
      match reuse'
      | None => Vector2f._from_csfml(_csfml.texCoords)
      | let reuse: Vector2f => reuse._set_csfml(_csfml.texCoords)
      end

    //fun ref _getStruct(): _Vertex => _csfml