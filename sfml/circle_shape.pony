//
// FFI declarations for CSFML functions
//
use @sfCircleShape_destroy[None](circle: _Shape box)
use @sfCircleShape_create[NullablePointer[_Shape]]()
use @sfCircleShape_setPositionA[None](circle: _Shape box, position: U64)
use @sfCircleShape_setPositionXY[None](circle: _Shape box, x: F32, y: F32)
use @sfCircleShape_setOriginA[None](circle: _Shape box, origin: U64)
use @sfCircleShape_setOriginXY[None](circle: _Shape box, x: F32, y: F32)
use @sfCircleShape_setScale[None](circle: _Shape box, factors: U64)
use @sfCircleShape_setRadius[None](circle: _Shape box, radius: F32)
use @sfCircleShape_setRotation[None](circle: _Shape box, angle: F32)
use @sfCircleShape_rotate[None](circle: _Shape box, angle: F32)
use @sfCircleShape_setFillColor[None](circle: _Shape box, color: U32)
use @sfCircleShape_setOutlineColor[None](circle: _Shape box, color: U32)
use @sfCircleShape_setPointCount[None](circle: _Shape box, count: USize)
use @sfCircleShape_setTexture[None](circle: _Shape box, texture: _Texture box, resetRect: I32)
use @sfCircleShape_setTextureRect[None](circle: _Shape box, rect: U128)
use @sfCircleShape_setOutlineThickness[None](circle: _Shape box, thickness: F32)

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class CircleShape
    var _csfml : _Shape ref

    new create()? => 
        _csfml = @sfCircleShape_create()()?
    
    fun ref _getCsfml(): _Shape =>
        _csfml

    fun ref setRadius(radius : F32) =>
        @sfCircleShape_setRadius(_csfml, radius)

    fun ref setSize(size : Vector2f) =>        
        @sfCircleShape_setRadius(_csfml, size.getX() / 2.0)
        @sfCircleShape_setScale(_csfml, Vector2f(1.0, size.getY()/size.getX())._u64())

    fun ref setFillColor(color : Color) =>
        @sfCircleShape_setFillColor(_csfml, color._u32())

    fun ref setOutlineColor(color : Color) =>
        @sfCircleShape_setOutlineColor(_csfml, color._u32())

    fun ref setOutlineThickness(thickness : F32) =>
        @sfCircleShape_setOutlineThickness(_csfml, thickness)

    fun ref setPointCount(count : USize) =>
        @sfCircleShape_setPointCount(_csfml, count)

    fun ref setPosition(position : Vector2f) =>
        @sfCircleShape_setPositionA(_csfml, position._u64())

    fun ref setPositionXY(x: F32, y: F32) =>
        @sfCircleShape_setPositionXY(_csfml, x, y)

    fun ref setScale(factors : Vector2f) =>
        @sfCircleShape_setScale(_csfml, factors._u64())

    fun ref setOrigin(origin : Vector2f) =>
        @sfCircleShape_setOriginA(_csfml, origin._u64())
    
    fun ref setOriginXY(x: F32, y: F32) =>
        @sfCircleShape_setOriginXY(_csfml, x, y)

    fun ref setRotation(angle : F32) =>
        @sfCircleShape_setRotation(_csfml, angle)

    fun ref rotate(angle : F32) =>
        @sfCircleShape_rotate(_csfml, angle)

    fun ref setTexture(texture : Texture, resetRect : Bool) =>
        let rrInt: I32 = if resetRect then 1 else 0 end
        @sfCircleShape_setTexture(_csfml, texture._getCsfml(), rrInt)

    fun ref setTextureRect(rect : IntRect) =>
        @sfCircleShape_setTextureRect(_csfml, rect._u128())

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        @sfCircleShape_destroy(_csfml)
