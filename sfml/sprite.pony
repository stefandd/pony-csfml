//
// FFI declarations for CSFML functions
//
use @sfSprite_create[NullablePointer[_Sprite]]()
use @sfSprite_setTexture[None](sprite: _Sprite box, texture: _Texture box, resetRect: I32)
use @sfSprite_getTexture[NullablePointer[_Texture]](sprite: _Sprite box)
use @sfSprite_destroy[None](sprite: _Sprite box)

// 
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _Sprite

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class Sprite
    var _csfml: _Sprite ref

    new create()? =>
        _csfml = @sfSprite_create()()?

    fun ref setTexture(texture: Texture ref, resetRect: Bool = false) =>
        let rrInt: I32 = if resetRect then 1 else 0 end
        @sfSprite_setTexture(_csfml, texture._getCsfml(), rrInt)
    
    // In (C)SFML, the texture returned is read-only (const).
    // In Pony, we use the `box` refcap to achieve the same.
    fun ref getTexture(): (Texture box | None) =>
        let nullable_texture = @sfSprite_getTexture(_csfml)
        try Texture._fromCsfml(nullable_texture()?) end

    fun ref _getCsfml(): _Sprite =>
        _csfml

    fun \deprecated\ ref destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        @sfSprite_destroy(_csfml)
