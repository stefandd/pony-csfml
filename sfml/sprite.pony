// CSFML Functions

use @sfSprite_create[_SpriteRaw]()
use @sfSprite_setTexture[None](sprite: _SpriteRaw box, texture: _TextureRaw box, resetRect: I32)
use @sfSprite_destroy[None](sprite: _SpriteRaw box)

// SFML Object

struct _Sprite
type _SpriteRaw is NullablePointer[_Sprite]

// Pony Abstaction

class Sprite
    var _raw: _SpriteRaw ref
    var _texture: (Texture ref | None)

    new create() =>
        _raw = @sfSprite_create()
        _texture = None

    fun ref setTexture(texture: Texture ref, resetRect: Bool = false) =>
        let rrInt: I32 = if resetRect then 1 else 0 end
        @sfSprite_setTexture(_raw, texture._getRaw(), rrInt)
        // Below, we keep a reference to the Pony Texture instance because we
        // don't want to loose track of the fact that it is the canonical Pony 
        // abstraction of for the SFML _Texture that is now owned by the Sprite.
        // This will be important in getTexture().
        _texture = texture
    
    // In (C)SFML, the texture returned is read-only (const).
    // In Pony, we use the `box` refcap to achieve the same.
    fun ref getTexture(): (Texture box | None) =>
        match _texture
            | let t: Texture => t
            | None => None
        end

    fun ref _getRaw(): _SpriteRaw =>
        _raw

    fun \deprecated\ ref destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfSprite_destroy(_raw) end
