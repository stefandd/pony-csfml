struct SFColor
    var r : U8
    var g : U8
    var b : U8
    var a : U8

    new create(r' : U8, g' : U8, b' : U8, a' : U8 = 255) =>
        r = r'; g = g'; b = b'; a = a'

    new copy(that': SFColor) =>
        r = that'.r
        g = that'.g
        b = that'.b
        a = that'.a

    new from_u32(col : U32) =>
        r = (col >> 24).u8()
        g = ((col >> 16) and 0xFF).u8()
        b = ((col >> 8) and 0xFF).u8()
        a = (col and 0xFF).u8()

    // REVIEW: Are these accessors required, given that the fields are not private?
    fun red() : U8 => r    
    fun green() : U8 => g
    fun blue() : U8 => b

    // Pony structs are passed by reference so for functions that need the struct itself we have to map to a value, in this case a U32
    fun u32() : U32 =>
        (a.u32() * 256 * 256 * 256) + (b.u32() * 256 * 256) + (g.u32() * 256) + (r.u32())


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
