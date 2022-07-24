use @sfCircleShape_destroy[None](circle : ShapeRaw box)
use @sfCircleShape_create[ShapeRaw]()
use @sfCircleShape_setPositionA[None](circle : ShapeRaw box, position : U64)
use @sfCircleShape_setOriginA[None](circle : ShapeRaw box, origin : U64)
use @sfCircleShape_setScale[None](circle : ShapeRaw box, factors : U64)
use @sfCircleShape_setRadius[None](circle : ShapeRaw box, radius : F32)
use @sfCircleShape_setRotation[None](circle : ShapeRaw box, angle : F32)
use @sfCircleShape_rotate[None](circle : ShapeRaw box, angle : F32)
use @sfCircleShape_setFillColor[None](circle : ShapeRaw box, color : U32)
use @sfCircleShape_setOutlineColor[None](circle : ShapeRaw box, color : U32)
use @sfCircleShape_setPointCount[None](circle : ShapeRaw box, count : USize)
use @sfCircleShape_setTexture[None](circle : ShapeRaw box, texture : TextureRaw, resetRect : I32)
use @sfCircleShape_setTextureRect[None](circle : ShapeRaw box, rect : U128)
use @sfCircleShape_setOutlineThickness[None](circle : ShapeRaw box, thickness : F32)

use @sfRectangleShape_destroy[None](Rectangle : ShapeRaw box)
use @sfRectangleShape_create[ShapeRaw]()
use @sfRectangleShape_setPositionA[None](Rectangle : ShapeRaw box, position : U64)
use @sfRectangleShape_setOriginA[None](Rectangle : ShapeRaw box, origin : U64)
use @sfRectangleShape_setScale[None](Rectangle : ShapeRaw box, factors : U64)
use @sfRectangleShape_setSize[None](Rectangle : ShapeRaw box, size : U64)
use @sfRectangleShape_setRotation[None](Rectangle : ShapeRaw box, angle : F32)
use @sfRectangleShape_rotate[None](Rectangle : ShapeRaw box, angle : F32)
use @sfRectangleShape_setFillColor[None](Rectangle : ShapeRaw box, color : U32)
use @sfRectangleShape_setOutlineColor[None](Rectangle : ShapeRaw box, color : U32)
use @sfRectangleShape_setPointCount[None](Rectangle : ShapeRaw box, count : USize)
use @sfRectangleShape_setTexture[None](Rectangle : ShapeRaw box, texture : TextureRaw, resetRect : I32)
use @sfRectangleShape_setTextureRect[None](Rectangle : ShapeRaw box, rect : U128)
use @sfRectangleShape_setOutlineThickness[None](Rectangle : ShapeRaw box, thickness : F32)

//use @memcpy[Pointer[None]](dest : Pointer[None], src : Pointer[None] box, n : USize)

type Shape is (CircleShape | RectangleShape)

struct _Shape
type ShapeRaw is NullablePointer[_Shape]

class CircleShape
    var _raw : ShapeRaw ref

    new create() => 
        _raw = @sfCircleShape_create()
    
    fun ref getRaw() : ShapeRaw =>
        _raw

    fun ref isNULL() : Bool =>
        _raw.is_none()

    fun ref destroy() =>
        if not _raw.is_none() then
             @sfCircleShape_destroy(_raw)
            _raw = ShapeRaw.none()
        end

    fun ref setRadius(radius : F32) =>
        @sfCircleShape_setRadius(_raw, radius)

    fun ref setSize(size : Vector2f) =>        
        @sfCircleShape_setRadius(_raw, size.x / 2.0)
        @sfCircleShape_setScale(_raw, Vector2f(1.0, size.y/size.x)._u64())

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
        if resetRect then
            @sfCircleShape_setTexture(_raw, texture.getRaw(), 1)
        else
            @sfCircleShape_setTexture(_raw, texture.getRaw(), 0)
        end

    fun ref setTextureRect(rect : IntRect) =>
        @sfCircleShape_setTextureRect(_raw, rect._u128())

    fun _final() =>
        if not _raw.is_none() then @sfCircleShape_destroy(_raw) end


class RectangleShape
    var _raw : ShapeRaw ref

    new create() => 
        _raw = @sfRectangleShape_create()
    
    fun ref getRaw() : ShapeRaw =>
        _raw

    fun ref isNULL() : Bool =>
        _raw.is_none()

    fun ref destroy() =>
        if not _raw.is_none() then
             @sfRectangleShape_destroy(_raw)
            _raw = ShapeRaw.none()
        end

    fun ref setRadius(radius : F32) =>
        @sfRectangleShape_setSize(_raw, (Vector2f(2.0 * radius, 2.0 * radius))._u64())

    fun ref setSize(size : Vector2f) =>
        @sfRectangleShape_setSize(_raw, size._u64())

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
        if resetRect then
            @sfRectangleShape_setTexture(_raw, texture.getRaw(), 1)
        else
            @sfRectangleShape_setTexture(_raw, texture.getRaw(), 0)
        end

    fun ref setTextureRect(rect : IntRect) =>
        @sfRectangleShape_setTextureRect(_raw, rect._u128())

    fun _final() =>
        if not _raw.is_none() then @sfRectangleShape_destroy(_raw) end
