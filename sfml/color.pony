//
// The SFML object as presented by CSFML
//
struct _Color
    var r: U8
    var g: U8
    var b: U8
    var a: U8

    new create(r': U8, g': U8, b': U8, a': U8 = 255) =>
        r = r' ; g = g' ; b = b' ; a = a'

    // We need a copy constructor to initialize colors embedded into larger structs.
    new copy(that: _Color) =>
        r = that.r ; g = that.g ; b = that.b ; a = that.a

    new fromInteger(int: U32) =>
        r = ((int >> 24) and 0xFF).u8()
        g = ((int >> 16) and 0xFF).u8()
        b = ((int >> 8 ) and 0xFF).u8()
        a = ((int >> 0 ) and 0xFF).u8()

    fun toInteger(): U32 =>
        (r.u32() << 24) + (g.u32() << 16) + (b.u32() << 8) + (a.u32() << 0)

    fun ref setFromInteger(int: U32) =>
        r = ((int >> 24) and 0xFF).u8()
        g = ((int >> 16) and 0xFF).u8()
        b = ((int >>  8) and 0xFF).u8()
        a = ((int >>  0) and 0xFF).u8()

    fun ref setFromRGBA(r': U8, g': U8, b': U8, a': U8 = 255) =>
        r = r' ; g = g' ; b = b' ; a = a'

    fun ref setFrom(that: _Color) =>
        r = that.r ; g = that.g ; b = that.b ; a = that.a

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

    new create(r: U8, g: U8, b: U8, a: U8 = 255) =>
        _csfml = _Color(r, g, b, a)

    new fromInteger(int: U32) =>
        _csfml = _Color.fromInteger(int)

    fun toInteger(): U32 =>
        _csfml.toInteger()

    fun ref setFromRGBA(r: U8, g: U8, b: U8, a: U8 = 255) =>
        """
        Mutates the color to the specified values
        """
        _csfml.setFromRGBA(r, g, b, a)

    fun ref setFromColor(that: Color) =>
        """
        Mutates the color to match the provided color
        """
        _csfml.setFrom(that._getCsfml())

    fun ref setAlpha(a: U8): Color =>
        """
        Mutates the color to the given alpha.
        """
        _csfml.a = a
        this

    fun ref getR(): U8 => _csfml.r
    fun ref getG(): U8 => _csfml.g
    fun ref getB(): U8 => _csfml.b
    fun ref getA(): U8 => _csfml.a

    fun ref setFromInteger(int: U32) =>
        """
        Mutates the color to match the provided integer
        """
        _csfml.setFromInteger(int)

    // These are SFML's predefined colors:
    
    new black() =>
        """
        Note: This is a static constant in SFML, but a constructor Pony-SFML.
        """
        _csfml = _Color(  0,   0,   0, 255)

    new white() =>
        """
        Note: This is a static constant in SFML, but a constructor Pony-SFML.
        """
        _csfml = _Color(255, 255, 255, 255)

    new red() =>
        """
        Note: This is a static constant in SFML, but a constructor Pony-SFML.
        """
        _csfml = _Color(255,   0,   0, 255)

    new green() =>
        """
        Note: This is a static constant in SFML, but a constructor Pony-SFML.
        """
        _csfml = _Color(  0, 255,   0, 255)

    new blue() =>
        """
        Note: This is a static constant in SFML, but a constructor Pony-SFML.
        """
        _csfml = _Color(  0,   0, 255, 255)

    new yellow() => 
        """
        Note: This is a static constant in SFML, but a constructor Pony-SFML.
        """
        _csfml = _Color(255, 255,   0, 255)

    new magenta() => 
        """
        Note: This is a static constant in SFML, but a constructor Pony-SFML.
        """
        _csfml = _Color(255,   0, 255, 255)

    new cyan() =>
        """
        Note: This is a static constant in SFML, but a constructor Pony-SFML.
        """
        _csfml = _Color(  0, 255, 255, 255)

    new transparent() =>
        """
        Note: This is a static constant in SFML, but a constructor Pony-SFML.
        """
        _csfml = _Color(  0,   0,   0,   0)


    //
    // Private methods
    //

    new _fromCsfml(csfml: _Color) => _csfml = csfml

    fun ref _setCsfml(csfml: _Color) => _csfml = csfml

    fun ref _getCsfml(): _Color => _csfml

    // Note that _from_u32 and _u32 are NOT the same as fromInteger and
    // toInteger! They probably produce DIFFERENT byte order, depending
    // on the endianess of your system. This is intentional.
    new _from_u32(coded: U32) => _csfml = _Color.from_u32(coded)
    fun ref _u32(): U32 => _csfml.u32()