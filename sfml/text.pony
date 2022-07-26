use @sfFont_createFromFile[FontRaw](filename : Pointer[U8 val] tag)
use @sfFont_destroy[None](font : FontRaw box)

use @sfText_create[TextRaw]()
use @sfText_setString[None](text : TextRaw box, str : Pointer[U8 val] tag)
use @sfText_setFont[None](text : TextRaw box, font : FontRaw box)
use @sfText_setCharacterSize[None](text : TextRaw box, size : U32)
use @sfText_setLineSpacing[None](text : TextRaw box, spacingFactor : F32)
use @sfText_setLetterSpacing[None](text : TextRaw box, spacingFactor : F32)
use @sfText_setStyle[None](text : TextRaw box, style : U32)
use @sfText_setColor[None](text : TextRaw box, color : U32)
use @sfText_setFillColor[None](text : TextRaw box, color : U32)
use @sfText_setOutlineColor[None](text : TextRaw box, color : U32)
use @sfText_setOutlineThickness[None](text : TextRaw box, thickness : F32)
use @sfText_setPositionA[None](text : TextRaw box, position : U64)
use @sfText_setScaleA[None](text : TextRaw box, factors : U64)
use @sfText_setOriginA[None](text : TextRaw box, origin : U64)
use @sfText_setRotation[None](text : TextRaw box, angle : F32)
use @sfText_getLocalBoundsA[None](text : TextRaw box, bounds : FloatRectRaw)
use @sfText_getGlobalBoundsA[None](text : TextRaw box, bounds : FloatRectRaw)
use @sfText_destroy[None](text : TextRaw box)

struct _Text
type TextRaw is NullablePointer[_Text]

struct _Font
type FontRaw is NullablePointer[_Font]

primitive TextStyle
    fun sfTextRegular() : U32       => 0      ///< Regular characters, no style
    fun sfTextBold() : U32          => 1 << 0 ///< Bold characters
    fun sfTextItalic() : U32        => 1 << 1 ///< Italic characters
    fun sfTextUnderlined() : U32    => 1 << 2 ///< Underlined characters
    fun sfTextStrikeThrough() : U32 => 1 << 3 ///< Strike through characters

class Font
    var _raw : FontRaw

    new create(file : String) =>
        _raw = @sfFont_createFromFile(file.cstring())

    fun ref _getRaw(): FontRaw =>
        _raw

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfFont_destroy(_raw) end

class Text
    var _raw : TextRaw

    new create() =>
        _raw = @sfText_create()

    fun setString(txt : String) =>
        @sfText_setString(_raw, txt.cstring())
    
    fun setFont(font : Font) =>
        @sfText_setFont(_raw, font._getRaw())
        
    fun setCharacterSize(size : U32) =>
        @sfText_setCharacterSize(_raw, size)

    fun setLineSpacing(spacing : F32) =>
        @sfText_setLineSpacing(_raw, spacing)
    
    fun setLetterSpacing(spacing : F32) =>
        @sfText_setLetterSpacing(_raw, spacing)

    fun setStyle(style : U32) =>
        @sfText_setStyle(_raw, style)

    fun setColor(color : Color) =>
        @sfText_setColor(_raw, color._u32())

    fun setFillColor(color : Color) =>
        @sfText_setFillColor(_raw, color._u32())

    fun setOutlineColor(color : Color) =>
        @sfText_setOutlineColor(_raw, color._u32())

    fun setOutlineThickness(thickness : F32) =>
        @sfText_setOutlineThickness(_raw, thickness)

    fun ref setPosition(position : Vector2f) =>
        @sfText_setPositionA(_raw, position._u64())

    fun ref setScale(factors : Vector2f) =>
        @sfText_setScaleA(_raw, factors._u64())

    fun ref setOrigin(origin : Vector2f) =>
        @sfText_setOriginA(_raw, origin._u64())
    
    fun ref setRotation(angle : F32) =>
        @sfText_setRotation(_raw, angle)

    fun ref getGlobalBounds() : FloatRect =>
        let rect = FloatRect._from_u128(0)
        if not _raw.is_none() then
            @sfText_getGlobalBoundsA(_raw, FloatRectRaw(rect))
            rect
        else
            rect
        end

    fun ref getLocalBounds() : FloatRect =>
        let rect = FloatRect._from_u128(0)
        if not _raw.is_none() then
            @sfText_getLocalBoundsA(_raw, FloatRectRaw(rect))
            rect
        else
            rect
        end

    fun ref _getRaw(): TextRaw =>
        _raw

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfText_destroy(_raw) end

