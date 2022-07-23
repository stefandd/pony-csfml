use @sfCircleShape_destroy[None](circle : SFShapeRaw box)
use @sfCircleShape_create[SFShapeRaw]()
use @sfCircleShape_setPositionA[None](circle : SFShapeRaw box, position : U64)
use @sfCircleShape_setOriginA[None](circle : SFShapeRaw box, origin : U64)
use @sfCircleShape_setScale[None](circle : SFShapeRaw box, factors : U64)
use @sfCircleShape_setRadius[None](circle : SFShapeRaw box, radius : F32)
use @sfCircleShape_setRotation[None](circle : SFShapeRaw box, angle : F32)
use @sfCircleShape_rotate[None](circle : SFShapeRaw box, angle : F32)
use @sfCircleShape_setFillColor[None](circle : SFShapeRaw box, color : U32)
use @sfCircleShape_setOutlineColor[None](circle : SFShapeRaw box, color : U32)
use @sfCircleShape_setPointCount[None](circle : SFShapeRaw box, count : USize)
use @sfCircleShape_setTexture[None](circle : SFShapeRaw box, texture : SFTextureRaw, resetRect : I32)
use @sfCircleShape_setTextureRect[None](circle : SFShapeRaw box, rect : U128)
use @sfCircleShape_setOutlineThickness[None](circle : SFShapeRaw box, thickness : F32)

use @sfRectangleShape_destroy[None](Rectangle : SFShapeRaw box)
use @sfRectangleShape_create[SFShapeRaw]()
use @sfRectangleShape_setPositionA[None](Rectangle : SFShapeRaw box, position : U64)
use @sfRectangleShape_setOriginA[None](Rectangle : SFShapeRaw box, origin : U64)
use @sfRectangleShape_setScale[None](Rectangle : SFShapeRaw box, factors : U64)
use @sfRectangleShape_setSize[None](Rectangle : SFShapeRaw box, size : U64)
use @sfRectangleShape_setRotation[None](Rectangle : SFShapeRaw box, angle : F32)
use @sfRectangleShape_rotate[None](Rectangle : SFShapeRaw box, angle : F32)
use @sfRectangleShape_setFillColor[None](Rectangle : SFShapeRaw box, color : U32)
use @sfRectangleShape_setOutlineColor[None](Rectangle : SFShapeRaw box, color : U32)
use @sfRectangleShape_setPointCount[None](Rectangle : SFShapeRaw box, count : USize)
use @sfRectangleShape_setTexture[None](Rectangle : SFShapeRaw box, texture : SFTextureRaw, resetRect : I32)
use @sfRectangleShape_setTextureRect[None](Rectangle : SFShapeRaw box, rect : U128)
use @sfRectangleShape_setOutlineThickness[None](Rectangle : SFShapeRaw box, thickness : F32)

//use @memcpy[Pointer[None]](dest : Pointer[None], src : Pointer[None] box, n : USize)

type SFShape is (SFCircleShape | SFRectangleShape)

struct _SFShape
type SFShapeRaw is NullablePointer[_SFShape]

class SFCircleShape
    var _raw : SFShapeRaw ref

    new create() => 
        _raw = @sfCircleShape_create()
    
    fun ref getRaw() : SFShapeRaw =>
        _raw

    fun ref isNULL() : Bool =>
        _raw.is_none()

    fun ref destroy() =>
        if not _raw.is_none() then
             @sfCircleShape_destroy(_raw)
            _raw = SFShapeRaw.none()
        end

    fun ref setRadius(radius : F32) =>
        @sfCircleShape_setRadius(_raw, radius)

    fun ref setSize(size : SFVector2f) =>        
        @sfCircleShape_setRadius(_raw, size.x / 2.0)
        @sfCircleShape_setScale(_raw, SFVector2f(1.0, size.y/size.x).u64())

    fun ref setFillColor(color : SFColor) =>
        @sfCircleShape_setFillColor(_raw, color._u32())

    fun ref setOutlineColor(color : SFColor) =>
        @sfCircleShape_setOutlineColor(_raw, color._u32())

    fun ref setOutlineThickness(thickness : F32) =>
        @sfCircleShape_setOutlineThickness(_raw, thickness)

    fun ref setPointCount(count : USize) =>
        @sfCircleShape_setPointCount(_raw, count)

    fun ref setPosition(position : SFVector2f) =>
        @sfCircleShape_setPositionA(_raw, position.u64())

    fun ref setScale(factors : SFVector2f) =>
        @sfCircleShape_setScale(_raw, factors.u64())

    fun ref setOrigin(origin : SFVector2f) =>
        @sfCircleShape_setOriginA(_raw, origin.u64())
    
    fun ref setRotation(angle : F32) =>
        @sfCircleShape_setRotation(_raw, angle)

    fun ref rotate(angle : F32) =>
        @sfCircleShape_rotate(_raw, angle)

    fun ref setTexture(texture : SFTexture, resetRect : Bool) =>
        if resetRect then
            @sfCircleShape_setTexture(_raw, texture.getRaw(), 1)
        else
            @sfCircleShape_setTexture(_raw, texture.getRaw(), 0)
        end

    fun ref setTextureRect(rect : SFIntRect) =>
        @sfCircleShape_setTextureRect(_raw, rect.u128())

    fun _final() =>
        if not _raw.is_none() then @sfCircleShape_destroy(_raw) end


class SFRectangleShape
    var _raw : SFShapeRaw ref

    new create() => 
        _raw = @sfRectangleShape_create()
    
    fun ref getRaw() : SFShapeRaw =>
        _raw

    fun ref isNULL() : Bool =>
        _raw.is_none()

    fun ref destroy() =>
        if not _raw.is_none() then
             @sfRectangleShape_destroy(_raw)
            _raw = SFShapeRaw.none()
        end

    fun ref setRadius(radius : F32) =>
        @sfRectangleShape_setSize(_raw, (SFVector2f(2.0 * radius, 2.0 * radius)).u64())

    fun ref setSize(size : SFVector2f) =>
        @sfRectangleShape_setSize(_raw, size.u64())

    fun ref setFillColor(color : SFColor) =>
        @sfRectangleShape_setFillColor(_raw, color._u32())

    fun ref setOutlineColor(color : SFColor) =>
        @sfRectangleShape_setOutlineColor(_raw, color._u32())

    fun ref setOutlineThickness(thickness : F32) =>
        @sfRectangleShape_setOutlineThickness(_raw, thickness)

    fun ref setPointCount(count : USize) =>
        None //@sfRectangleShape_setPointCount(_raw, count)

    fun ref setPosition(position : SFVector2f) =>
        @sfRectangleShape_setPositionA(_raw, position.u64())

    fun ref setScale(factors : SFVector2f) =>
        @sfRectangleShape_setScale(_raw, factors.u64())

    fun ref setOrigin(origin : SFVector2f) =>
        @sfRectangleShape_setOriginA(_raw, origin.u64())
    
    fun ref setRotation(angle : F32) =>
        @sfRectangleShape_setRotation(_raw, angle)

    fun ref rotate(angle: F32) =>
        @sfRectangleShape_rotate(_raw, angle)

    fun ref setTexture(texture : SFTexture, resetRect : Bool) =>
        if resetRect then
            @sfRectangleShape_setTexture(_raw, texture.getRaw(), 1)
        else
            @sfRectangleShape_setTexture(_raw, texture.getRaw(), 0)
        end

    fun ref setTextureRect(rect : SFIntRect) =>
        @sfRectangleShape_setTextureRect(_raw, rect.u128())

    fun _final() =>
        if not _raw.is_none() then @sfRectangleShape_destroy(_raw) end
