struct _Color
    var r : U8
    var g : U8
    var b : U8
    var a : U8

    new create(r': U8, g': U8, b': U8, a': U8 = 255) =>
        r = r' ; g = g' ; b = b' ; a = a'

    // We need a copy constructor to initialize colors embedded into larger structs.
    new copy(that': _Color) =>
        "Creates a new color by copying an existing color."
        r = that'.r ; g = that'.g ; b = that'.b ; a = that'.a

    // Pony structs can't be passed by value through Pony's FFI.
    // So for C funcs that expect structs by value we define a map to/from some unsigned int type.

    new from_u32(coded': U32) =>
        r = 0 ; g = 0 ; b = 0 ; a = 0
        var coded: U32 = coded'
        @memcpy(NullablePointer[_Color](this), addressof coded, coded.bytewidth())

    fun ref u32(): U32 =>
        var coded: U32 = 0
        @memcpy(addressof coded, NullablePointer[_Color](this), coded.bytewidth())
        coded

class Color
    var _csfml: _Color

    new create(r' : U8, g' : U8, b' : U8, a' : U8 = 255) =>
        _csfml = _Color(r', g', b', a')

    new _from_csfml(csfml: _Color) =>
      _csfml = csfml

    fun ref _set_csfml(csfml: _Color): Color =>
      _csfml = csfml
      this

    new fromInteger(col : U32) =>
        _csfml = _Color(
            (col >> 24).u8(),
            ((col >> 16) and 0xFF).u8(),
            ((col >> 8) and 0xFF).u8(),
            ((col >> 0) and 0xFF).u8() )

    fun toInteger() : U32 =>
        (_csfml.r.u32() << 24) +
        (_csfml.g.u32() << 16) +
        (_csfml.b.u32() << 8) +
        (_csfml.a.u32() << 0)

    fun ref setFromRGBA(r' : U8, g' : U8, b' : U8, a' : U8 = 255) =>
        "Mutates the color to the specified values"
        _csfml.r = r'
        _csfml.g = g'
        _csfml.b = b'
        _csfml.a = a'

    fun ref setFromColor(that': Color) =>
        "Mutates the color to match the provided color"
        _csfml.r = that'._csfml.r
        _csfml.g = that'._csfml.g
        _csfml.b = that'._csfml.b
        _csfml.a = that'._csfml.a

    // These are SFML's predefined colors:
    new black()       => _csfml = _Color(  0,   0,   0, 255)
    new white()       => _csfml = _Color(255, 255, 255, 255)
    new red()         => _csfml = _Color(255,   0,   0, 255)
    new green()       => _csfml = _Color(  0, 255,   0, 255)
    new blue()        => _csfml = _Color(  0,   0, 255, 255)
    new yellow()      => _csfml = _Color(255, 255,   0, 255)
    new magenta()     => _csfml = _Color(255,   0, 255, 255)
    new cyan()        => _csfml = _Color(  0, 255, 255, 255)
    new transparent() => _csfml = _Color(  0,   0,   0,   0)

    fun ref _getStruct(): _Color => _csfml

    // Note that _from_u32 and _u32 are NOT the same as fromInteger and
    // toInteger! They probably produce DIFFERENT byte order, depending
    // on the endianess of your system. This is intentional.
    //
    new _from_u32(coded: U32) => _csfml = _Color.from_u32(coded)
    fun ref _u32(): U32 => _csfml.u32()


struct IntRect
    let left : I32
    let top : I32
    let width : I32
    let height : I32

    new create(left' : I32, top' : I32, width' : I32, height' : I32) =>
        left = left'
        top = top'
        width = width'
        height = height'

    // Pony structs can't be passed by value through Pony's FFI.
    // So for C funcs that expect structs by value we define a map to/from some unsigned int type.

    fun ref _u128() : U128 =>
        var tmp : U128 = 0
        @memcpy(addressof tmp, IntRectRaw(this), USize(16))
        tmp

type IntRectRaw is NullablePointer[IntRect]

struct FloatRect
    let left : F32
    let top : F32
    let width : F32
    let height : F32

    new create(left' : F32, top' : F32, width' : F32, height' : F32) =>
        left = left'
        top = top'
        width = width'
        height = height'

    // Pony structs can't be passed by value through Pony's FFI.
    // So for C funcs that expect structs by value we define a map to/from some unsigned int type.

    fun ref _u128() : U128 =>
        var tmp : U128 = 0
        @memcpy(addressof tmp, FloatRectRaw(this), USize(16))
        tmp

    new _from_u128(chunk : U128) =>
        left = 0; top = 0; width = 0; height = 0
        var tmp : U128 = chunk
        @memcpy(FloatRectRaw(this), addressof tmp, USize(16))

type FloatRectRaw is NullablePointer[FloatRect]

struct _Vector2f
    var x : F32
    var y : F32

    new create(x' : F32, y' : F32) =>
        x = x'
        y = y'

    new copy(that: _Vector2f) =>
        x = that.x
        y = that.y

    // Pony structs can't be passed by value through Pony's FFI.
    // So for C funcs that expect structs by value we define a map to/from some unsigned int type.

    fun ref u64() : U64 =>
        var tmp : U64 = 0
        @memcpy(addressof tmp, NullablePointer[_Vector2f](this), USize(8))
        tmp

class Vector2f
    var _csfml: _Vector2f

    new create(x: F32, y: F32) => _csfml = _Vector2f(x, y)

    new _from_csfml(csfml: _Vector2f) =>
      _csfml = csfml

    fun ref _set_csfml(csfml: _Vector2f): Vector2f =>
      _csfml = csfml
      this

    fun getX(): F32 => _csfml.x
    fun getY(): F32 => _csfml.y

    fun ref _u64(): U64 => _csfml.u64()

    fun ref _getStruct(): _Vector2f => _csfml


struct Vector2u
    var x : U32
    var y : U32

    new create(x' : U32, y' : U32) =>
        x = x'
        y = y'

    // Pony structs can't be passed by value through Pony's FFI.
    // So for C funcs that expect structs by value we define a map to/from some unsigned int type.

    fun ref _u64() : U64 =>
        var tmp : U64 = 0
        @memcpy(addressof tmp, Vector2uRaw(this), USize(8))
        tmp

    new _from_u64(chunk : U64) =>
        var tmp = Vector2u(0, 0)
        var tmp2 = chunk
        @memcpy(Vector2uRaw(tmp), addressof tmp2, USize(8))
        x = tmp.x
        y = tmp.y

type Vector2uRaw is NullablePointer[Vector2u]

struct _Vertex
    embed position:  _Vector2f
    embed color:     _Color
    embed texCoords: _Vector2f

    new create(position': Vector2f, color': Color, texCoords': Vector2f = Vector2f(0,0)) =>
      position  = _Vector2f.copy(position'._getStruct())
      color     = _Color.copy(color'._getStruct())
      texCoords = _Vector2f.copy(texCoords'._getStruct())

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