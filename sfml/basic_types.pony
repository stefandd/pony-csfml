struct SFColor
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
    new copy(that': SFColor) =>
        "Creates a new color by copying an existing color."
        r = that'.r ; g = that'.g ; b = that'.b ; a = that'.a

    new fromInteger(col : U32) =>
        r = (col >> 24).u8()
        g = ((col >> 16) and 0xFF).u8()
        b = ((col >> 8) and 0xFF).u8()
        a = ((col >> 0) and 0xFF).u8()

    fun box toInteger() : U32 =>
        (r.u32() << 24) + (g.u32() << 16) + (b.u32() << 8) + (a.u32() << 0)

    fun ref setFromRGBA(r' : U8, g' : U8, b' : U8, a' : U8 = 255) =>
        "Mutates the color to the specified values"
        r = r' ; g = g' ; b = b' ; a = a'

    fun ref setFromColor(that': SFColor) =>
        "Mutates the color to match the provided color"
        r = that'.r ; g = that'.g ; b = that'.b ; a = that'.a

    // Pony structs are passed by reference so for functions that need the struct itself we have to map to a value, in this case a U32
    // TODO: These will be made private in a future commit
    fun box u32() : U32 =>
        (a.u32() * 256 * 256 * 256) + (b.u32() * 256 * 256) + (g.u32() * 256) + (r.u32())
    new from_u32(col: U32) =>
        a = (col >> 24).u8()
        b = ((col >> 16) and 0xFF).u8()
        g = ((col >> 8) and 0xFF).u8()
        r = ((col >> 0) and 0xFF).u8()

struct SFIntRect
    let left : I32
    let top : I32
    let width : I32
    let height : I32

    new create(left' : I32, top' : I32, width' : I32, height' : I32) =>
        left = left'
        top = top'
        width = width'
        height = height'

    // Pony structs are passed by reference so for functions that need the struct itself we have to map to a value
    fun ref u128() : U128 =>
        var tmp : U128 = 0
        @memcpy(addressof tmp, SFIntRectRaw(this), USize(16))
        tmp

type SFIntRectRaw is NullablePointer[SFIntRect]

struct SFFloatRect
    let left : F32
    let top : F32
    let width : F32
    let height : F32

    new create(left' : F32, top' : F32, width' : F32, height' : F32) =>
        left = left'
        top = top'
        width = width'
        height = height'

    new from_u128(chunk : U128) =>
        left = 0; top = 0; width = 0; height = 0
        var tmp : U128 = chunk
        @memcpy(SFFloatRectRaw(this), addressof tmp, USize(16))

    // Pony structs are passed by reference so for functions that need the struct itself we have to map to a value
    fun ref u128() : U128 =>
        var tmp : U128 = 0
        @memcpy(addressof tmp, SFFloatRectRaw(this), USize(16))
        tmp

type SFFloatRectRaw is NullablePointer[SFFloatRect]

struct SFVector2f
    var x : F32
    var y : F32

    new create(x' : F32, y' : F32) =>
        x = x'
        y = y'

    new copy(that: SFVector2f) =>
        x = that.x
        y = that.y

    // Pony structs are passed by reference so for functions that need the struct itself we have to map to a value
    fun ref u64() : U64 =>
        var tmp : U64 = 0
        @memcpy(addressof tmp, SFVector2fRaw(this), USize(8))
        tmp

type SFVector2fRaw is NullablePointer[SFVector2f]

struct SFVector2u
    var x : U32
    var y : U32

    new create(x' : U32, y' : U32) =>
        x = x'
        y = y'

    // Pony structs are passed by reference so for functions that need the struct itself we have to map to a value
    fun ref u64() : U64 =>
        var tmp : U64 = 0
        @memcpy(addressof tmp, SFVector2uRaw(this), USize(8))
        tmp

    new from_u64(chunk : U64) =>
        var tmp = SFVector2u(0, 0)
        var tmp2 = chunk
        @memcpy(SFVector2uRaw(tmp), addressof tmp2, USize(8))
        x = tmp.x
        y = tmp.y

type SFVector2uRaw is NullablePointer[SFVector2u]

struct SFVertex
    embed position: SFVector2f ///< Position of the vertex
    embed color : SFColor ///< Color of the vertex
    embed texCoords: SFVector2f ///< Coordinates of the texture's pixel to map to the vertex
 
    new create(position': SFVector2f, color': SFColor, texCoords': SFVector2f = SFVector2f(0,0)) =>
      position = SFVector2f.copy(position')
      color = SFColor.copy(color')
      texCoords = SFVector2f.copy(texCoords')

type SFVertexRaw is NullablePointer[SFVertex]

primitive SFPrimitiveType
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
