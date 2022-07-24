struct Color
    var r : U8
    var g : U8
    var b : U8
    var a : U8
    
    new create(r' : U8, g' : U8, b' : U8, a' : U8 = 255) =>
        r = r' ; g = g' ; b = b' ; a = a'

    // These are SFML's predefined colors:
    new black() => r = 0 ; g = 0 ; b = 0 ; a = 255
    new white() => r = 255 ; g = 255 ; b = 255 ; a = 255
    new red() => r = 255 ; g = 0 ; b = 0 ; a = 255
    new green() => r = 0 ; g = 255 ; b = 0 ; a = 255
    new blue() => r = 0 ; g = 0 ; b = 255 ; a = 255
    new yellow() => r = 255 ; g = 255 ; b = 0 ; a = 255
    new magenta() => r = 255 ; g = 0 ; b = 255 ; a = 255
    new cyan() => r = 0 ; g = 255 ; b = 255 ; a = 255
    new transparent() => r = 0 ; g = 0 ; b = 0 ; a = 0

    // We need a copy constructor to initialize colors embedded into larger structs.
    new copy(that': Color) =>
        "Creates a new color by copying an existing color."
        r = that'.r ; g = that'.g ; b = that'.b ; a = that'.a

    new fromInteger(col : U32) =>
        r = (col >> 24).u8()
        g = ((col >> 16) and 0xFF).u8()
        b = ((col >> 8) and 0xFF).u8()
        a = ((col >> 0) and 0xFF).u8()

    fun toInteger() : U32 =>
        (r.u32() << 24) + (g.u32() << 16) + (b.u32() << 8) + (a.u32() << 0)

    fun ref setFromRGBA(r' : U8, g' : U8, b' : U8, a' : U8 = 255) =>
        "Mutates the color to the specified values"
        r = r' ; g = g' ; b = b' ; a = a'

    fun ref setFromColor(that': Color) =>
        "Mutates the color to match the provided color"
        r = that'.r ; g = that'.g ; b = that'.b ; a = that'.a

    // Pony structs can't be passed by value through Pony's FFI.
    // So for C funcs that expect structs by value we define a map to/from some unsigned int type.

    new _from_u32(coded': U32) =>
        r = 0 ; g = 0 ; b = 0 ; a = 0
        var coded: U32 = coded'
        @memcpy(ColorRaw(this), addressof coded, coded.bytewidth())

    fun ref _u32(): U32 =>
        var coded: U32 = 0
        @memcpy(addressof coded, ColorRaw(this), coded.bytewidth())
        coded

type ColorRaw is NullablePointer[Color]


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

struct Vector2f
    var x : F32
    var y : F32

    new create(x' : F32, y' : F32) =>
        x = x'
        y = y'

    new copy(that: Vector2f) =>
        x = that.x
        y = that.y

    // Pony structs can't be passed by value through Pony's FFI.
    // So for C funcs that expect structs by value we define a map to/from some unsigned int type.

    fun ref _u64() : U64 =>
        var tmp : U64 = 0
        @memcpy(addressof tmp, Vector2fRaw(this), USize(8))
        tmp

type Vector2fRaw is NullablePointer[Vector2f]

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

struct Vertex
    embed position: Vector2f ///< Position of the vertex
    embed color : Color ///< Color of the vertex
    embed texCoords: Vector2f ///< Coordinates of the texture's pixel to map to the vertex
 
    new create(position': Vector2f, color': Color, texCoords': Vector2f = Vector2f(0,0)) =>
      position = Vector2f.copy(position')
      color = Color.copy(color')
      texCoords = Vector2f.copy(texCoords')

type VertexRaw is NullablePointer[Vertex]

primitive PrimitiveType
    fun sfPoints() : I32 =>         0
    fun sfLines() : I32 =>          1
    fun sfLineStrip() : I32 =>      2
    fun sfTriangles() : I32 =>      3
    fun sfTriangleStrip() : I32 =>  4
    fun sfTriangleFan() : I32 =>    5
    fun sfQuads() : I32 =>          6
    // Deprecated names
    fun sfLinesStrip() : I32 =>     2
    fun sfTrianglesStrip() : I32 => 4
    fun sfTrianglesFan() : I32 =>   5
