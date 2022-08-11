// 
// The SFML object as presented by CSFML
//
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

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
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