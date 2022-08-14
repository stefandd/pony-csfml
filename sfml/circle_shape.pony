//
// FFI declarations for CSFML functions
//
use @sfCircleShape_destroy[None](circle: _ShapeRaw box)
use @sfCircleShape_create[_ShapeRaw]()
use @sfCircleShape_setPositionA[None](circle: _ShapeRaw box, position: U64)
use @sfCircleShape_setOriginA[None](circle: _ShapeRaw box, origin: U64)
use @sfCircleShape_setScale[None](circle: _ShapeRaw box, factors: U64)
use @sfCircleShape_setRadius[None](circle: _ShapeRaw box, radius: F32)
use @sfCircleShape_setRotation[None](circle: _ShapeRaw box, angle: F32)
use @sfCircleShape_rotate[None](circle: _ShapeRaw box, angle: F32)
use @sfCircleShape_setFillColor[None](circle: _ShapeRaw box, color: U32)
use @sfCircleShape_setOutlineColor[None](circle: _ShapeRaw box, color: U32)
use @sfCircleShape_setPointCount[None](circle: _ShapeRaw box, count: USize)
use @sfCircleShape_setTexture[None](circle: _ShapeRaw box, texture: _Texture box, resetRect: I32)
use @sfCircleShape_setTextureRect[None](circle: _ShapeRaw box, rect: U128)
use @sfCircleShape_setOutlineThickness[None](circle: _ShapeRaw box, thickness: F32)

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class CircleShape
    var _raw : _ShapeRaw ref

    new create()? => 
        _raw = @sfCircleShape_create()
        if _raw.is_none() then error end
    
    fun ref _getRaw(): _ShapeRaw =>
        _raw

    fun ref setRadius(radius : F32) =>
        @sfCircleShape_setRadius(_raw, radius)

    fun ref setSize(size : Vector2f) =>        
        @sfCircleShape_setRadius(_raw, size.getX() / 2.0)
        @sfCircleShape_setScale(_raw, Vector2f(1.0, size.getY()/size.getX())._u64())

    fun ref setFillColor(color : Color) =>
        @sfCircleShape_setFillColor(_raw, color._u32())

    fun ref setOutlineColor(color : Color) =>
        @sfCircleShape_setOutlineColor(_raw, color._u32())

    fun ref setOutlineThickness(thickness : F32) =>
        @sfCircleShape_setOutlineThickness(_raw, thickness)

    fun ref setPointCount(count : USize) =>
        @sfCircleShape_setPointCount(_raw, count)

    fun ref setPosition(position : Vector2f) =>
        @sfCircleShape_setPositionA(_raw, position._u64())

    fun ref setScale(factors : Vector2f) =>
        @sfCircleShape_setScale(_raw, factors._u64())

    fun ref setOrigin(origin : Vector2f) =>
        @sfCircleShape_setOriginA(_raw, origin._u64())
    
    fun ref setRotation(angle : F32) =>
        @sfCircleShape_setRotation(_raw, angle)

    fun ref rotate(angle : F32) =>
        @sfCircleShape_rotate(_raw, angle)

    fun ref setTexture(texture : Texture, resetRect : Bool) =>
        let rrInt: I32 = if resetRect then 1 else 0 end
        @sfCircleShape_setTexture(_raw, texture._getCsfml(), rrInt)

    fun ref setTextureRect(rect : IntRect) =>
        @sfCircleShape_setTextureRect(_raw, rect._u128())

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfCircleShape_destroy(_raw) end
