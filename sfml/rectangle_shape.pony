//
// CSFML FFI Functions
//
use @sfRectangleShape_destroy[None](rectangle: _Shape box)
use @sfRectangleShape_create[NullablePointer[_Shape]]()
use @sfRectangleShape_setPositionA[None](rectangle: _Shape box, position: U64)
use @sfRectangleShape_setOriginA[None](rectangle: _Shape box, origin: U64)
use @sfRectangleShape_setScale[None](rectangle: _Shape box, factors: U64)
use @sfRectangleShape_setSizeA[None](rectangle: _Shape box, size: U64)
use @sfRectangleShape_setRotation[None](rectangle: _Shape box, angle: F32)
use @sfRectangleShape_rotate[None](rectangle: _Shape box, angle: F32)
use @sfRectangleShape_setFillColor[None](rectangle: _Shape box, color: U32)
use @sfRectangleShape_setOutlineColor[None](rectangle: _Shape box, color: U32)
use @sfRectangleShape_setPointCount[None](rectangle: _Shape box, count: USize)
use @sfRectangleShape_setTexture[None](rectangle: _Shape box, texture: _Texture box, resetRect: I32)
use @sfRectangleShape_setTextureRect[None](rectangle: _Shape box, rect: U128)
use @sfRectangleShape_setOutlineThickness[None](rectangle: _Shape box, thickness: F32)

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class RectangleShape
    var _csfml : _Shape ref

    new create()? => 
        _csfml = @sfRectangleShape_create()()?
    
    fun ref _getCsfml(): _Shape =>
        _csfml

    fun ref setRadius(radius : F32) =>
        @sfRectangleShape_setSizeA(_csfml, (Vector2f(2.0 * radius, 2.0 * radius))._u64())

    fun ref setSize(size : Vector2f) =>
        @sfRectangleShape_setSizeA(_csfml, size._u64())

    fun ref setFillColor(color : Color) =>
        @sfRectangleShape_setFillColor(_csfml, color._u32())

    fun ref setOutlineColor(color : Color) =>
        @sfRectangleShape_setOutlineColor(_csfml, color._u32())

    fun ref setOutlineThickness(thickness : F32) =>
        @sfRectangleShape_setOutlineThickness(_csfml, thickness)

    fun ref setPointCount(count : USize) =>
        None //@sfRectangleShape_setPointCount(_csfml, count)

    fun ref setPosition(position : Vector2f) =>
        @sfRectangleShape_setPositionA(_csfml, position._u64())

    fun ref setScale(factors : Vector2f) =>
        @sfRectangleShape_setScale(_csfml, factors._u64())

    fun ref setOrigin(origin : Vector2f) =>
        @sfRectangleShape_setOriginA(_csfml, origin._u64())
    
    fun ref setRotation(angle : F32) =>
        @sfRectangleShape_setRotation(_csfml, angle)

    fun ref rotate(angle: F32) =>
        @sfRectangleShape_rotate(_csfml, angle)

    fun ref setTexture(texture : Texture, resetRect : Bool) =>
        let rrInt: I32 = if resetRect then 1 else 0 end
        @sfRectangleShape_setTexture(_csfml, texture._getCsfml(), rrInt)
 
    fun ref setTextureRect(rect : IntRect) =>
        @sfRectangleShape_setTextureRect(_csfml, rect._u128())

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        @sfRectangleShape_destroy(_csfml)
