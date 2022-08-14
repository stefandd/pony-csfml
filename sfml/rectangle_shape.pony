//
// CSFML FFI Functions
//
use @sfRectangleShape_destroy[None](rectangle: _ShapeRaw box)
use @sfRectangleShape_create[_ShapeRaw]()
use @sfRectangleShape_setPositionA[None](rectangle: _ShapeRaw box, position: U64)
use @sfRectangleShape_setOriginA[None](rectangle: _ShapeRaw box, origin: U64)
use @sfRectangleShape_setScale[None](rectangle: _ShapeRaw box, factors: U64)
use @sfRectangleShape_setSizeA[None](rectangle: _ShapeRaw box, size: U64)
use @sfRectangleShape_setRotation[None](rectangle: _ShapeRaw box, angle: F32)
use @sfRectangleShape_rotate[None](rectangle: _ShapeRaw box, angle: F32)
use @sfRectangleShape_setFillColor[None](rectangle: _ShapeRaw box, color: U32)
use @sfRectangleShape_setOutlineColor[None](rectangle: _ShapeRaw box, color: U32)
use @sfRectangleShape_setPointCount[None](rectangle: _ShapeRaw box, count: USize)
use @sfRectangleShape_setTexture[None](rectangle: _ShapeRaw box, texture: _Texture box, resetRect: I32)
use @sfRectangleShape_setTextureRect[None](rectangle: _ShapeRaw box, rect: U128)
use @sfRectangleShape_setOutlineThickness[None](rectangle: _ShapeRaw box, thickness: F32)

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class RectangleShape
    var _raw : _ShapeRaw ref

    new create()? => 
        _raw = @sfRectangleShape_create()
        if _raw.is_none() then error end
    
    fun ref _getRaw(): _ShapeRaw =>
        _raw

    fun ref setRadius(radius : F32) =>
        @sfRectangleShape_setSizeA(_raw, (Vector2f(2.0 * radius, 2.0 * radius))._u64())

    fun ref setSize(size : Vector2f) =>
        @sfRectangleShape_setSizeA(_raw, size._u64())

    fun ref setFillColor(color : Color) =>
        @sfRectangleShape_setFillColor(_raw, color._u32())

    fun ref setOutlineColor(color : Color) =>
        @sfRectangleShape_setOutlineColor(_raw, color._u32())

    fun ref setOutlineThickness(thickness : F32) =>
        @sfRectangleShape_setOutlineThickness(_raw, thickness)

    fun ref setPointCount(count : USize) =>
        None //@sfRectangleShape_setPointCount(_raw, count)

    fun ref setPosition(position : Vector2f) =>
        @sfRectangleShape_setPositionA(_raw, position._u64())

    fun ref setScale(factors : Vector2f) =>
        @sfRectangleShape_setScale(_raw, factors._u64())

    fun ref setOrigin(origin : Vector2f) =>
        @sfRectangleShape_setOriginA(_raw, origin._u64())
    
    fun ref setRotation(angle : F32) =>
        @sfRectangleShape_setRotation(_raw, angle)

    fun ref rotate(angle: F32) =>
        @sfRectangleShape_rotate(_raw, angle)

    fun ref setTexture(texture : Texture, resetRect : Bool) =>
        let rrInt: I32 = if resetRect then 1 else 0 end
        @sfRectangleShape_setTexture(_raw, texture._getCsfml(), rrInt)
 
    fun ref setTextureRect(rect : IntRect) =>
        @sfRectangleShape_setTextureRect(_raw, rect._u128())

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfRectangleShape_destroy(_raw) end
