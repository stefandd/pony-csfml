// 
// The SFML object as presented by CSFML
// 
struct _Vertex
    embed position:  _Vector2f
    embed color:     _Color
    embed texCoords: _Vector2f

    new create(position': Vector2f, color': Color, texCoords': Vector2f = Vector2f(0,0)) =>
      position  = _Vector2f.copy(position'._getCsfml())
      color     = _Color.copy(color'._getCsfml())
      texCoords = _Vector2f.copy(texCoords'._getCsfml())

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class Vertex
    var _csfml: _Vertex

    // 
    // Public
    //

    new create(position: Vector2f, color: Color, texCoords: Vector2f = Vector2f(0,0)) =>
      _csfml = _Vertex(position, color, texCoords)

    fun ref getPosition(): Vector2f =>
      """
      Warning: This allocates an object every time it is called.
      Consider getPositionX & getPositionY instead, in performance sensitive cases.
      """
      Vector2f._fromCsfml(_csfml.position)

    fun ref getColor(): Color =>
      """
      Warning: This allocates an object every time it is called.
      Consider getColorAsInteger instead, in performance sensitive cases.
      """
      Color._fromCsfml(_csfml.color)

    fun ref getTexCoords(): Vector2f =>
      """
      Warning: This allocates an object every time it is called.
      Consider getTexOrdX & getTexOrdY instead, in performance sensitive cases.      
      """
      Vector2f._fromCsfml(_csfml.texCoords)

    fun ref setPosition(position: Vector2f) =>
      """
      See setPositionX & setPositionY if you don't want to allocate a Vector2f for this method.
      """    
      _csfml.position.setFrom(position._getCsfml())

    fun ref setColor(color: Color) =>
      """
      See setColorFromInteger if you don't want to allocate a Color for this method.
      """
      _csfml.color.setFrom(color._getCsfml())

    fun ref setTexCoords(coords: Vector2f) =>
      """
      See setTexOrdX & setTexOrdY if you don't want to allocate a Vector2f for this method.
      """
      _csfml.texCoords.setFrom(coords._getCsfml())

    // These are not part of standard SFML.
    // They are added for those who want to manipulate vertices without allocating Vector2f or Color instance.
    fun getPositionX(): F32 => _csfml.position.x
    fun getPositionY(): F32 => _csfml.position.y
    fun getTexOrdX(): F32 => _csfml.texCoords.x
    fun getTexOrdY(): F32 => _csfml.texCoords.y
    fun getColorAsInteger(): U32 => _csfml.color.toInteger()
    fun ref setPositionX(x: F32) => _csfml.position.x = x
    fun ref setPositionY(y: F32) => _csfml.position.y = y
    fun ref setTexOrdX(x: F32) => _csfml.texCoords.x = x
    fun ref setTexOrdY(y: F32) => _csfml.texCoords.y = y
    fun ref setColorFromInteger(int: U32) => _csfml.color.setFromInteger(int)


    //
    // Private 
    //
  
    new _fromCsfml(v: _Vertex) =>
      _csfml = v

    fun ref _setCsfml(v: _Vertex): Vertex =>
      _csfml = v
      this

    //fun ref _getStruct(): _Vertex => _csfml