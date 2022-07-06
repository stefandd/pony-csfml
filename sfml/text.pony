use @sfFont_createFromFile[SFFontRaw](filename : Pointer[U8 val] tag)
use @sfFont_destroy[None](font : SFFontRaw box)

use @sfText_create[SFTextRaw]()
use @sfText_setString[None](text : SFTextRaw box, str : Pointer[U8 val] tag)
use @sfText_setFont[None](text : SFTextRaw box, font : SFFontRaw)
use @sfText_setCharacterSize[None](text : SFTextRaw box, size : U32)
use @sfText_setLineSpacing[None](text : SFTextRaw box, spacingFactor : F32)
use @sfText_setLetterSpacing[None](text : SFTextRaw box, spacingFactor : F32)
use @sfText_setStyle[None](text : SFTextRaw box, style : U32)
use @sfText_setColor[None](text : SFTextRaw box, color : U32)
use @sfText_setFillColor[None](text : SFTextRaw box, color : U32)
use @sfText_setOutlineColor[None](text : SFTextRaw box, color : U32)
use @sfText_setOutlineThickness[None](text : SFTextRaw box, thickness : F32)
use @sfText_setPosition[None](text : SFTextRaw box, position : U64)
use @sfText_setScale[None](text : SFTextRaw box, factors : U64)
use @sfText_setOrigin[None](text : SFTextRaw box, origin : U64)
use @sfText_setRotation[None](text : SFTextRaw box, angle : F32)
use @sfText_getLocalBoundsA[None](text : SFTextRaw box, bounds : SFFloatRectRaw)
use @sfText_getGlobalBoundsA[None](text : SFTextRaw box, bounds : SFFloatRectRaw)
use @sfText_destroy[None](text : SFTextRaw box)

struct _SFText
type SFTextRaw is NullablePointer[_SFText]

struct _SFFont
type SFFontRaw is NullablePointer[_SFFont]

primitive SFTextStyle
    fun sfTextRegular() : U32       => 0      ///< Regular characters, no style
    fun sfTextBold() : U32          => 1 << 0 ///< Bold characters
    fun sfTextItalic() : U32        => 1 << 1 ///< Italic characters
    fun sfTextUnderlined() : U32    => 1 << 2 ///< Underlined characters
    fun sfTextStrikeThrough() : U32 => 1 << 3 ///< Strike through characters

class SFFont
    var _raw : SFFontRaw

    new create(file : String) =>
        _raw = @sfFont_createFromFile(file.cstring())

    fun ref getRaw() : SFFontRaw =>
        _raw

    fun ref isNULL() : Bool =>
        _raw.is_none()

    fun ref destroy() =>
        if not _raw.is_none() then
             @sfFont_destroy(_raw)
            _raw = SFFontRaw.none()
        end

    fun _final() =>
        if not _raw.is_none() then @sfFont_destroy(_raw) end

class SFText
    var _raw : SFTextRaw

    new create() =>
        _raw = @sfText_create()

    fun setString(txt : String) =>
        @sfText_setString(_raw, txt.cstring())
    
    fun setFont(font : SFFont) =>
        @sfText_setFont(_raw, font.getRaw())
        
    fun setCharacterSize(size : U32) =>
        @sfText_setCharacterSize(_raw, size)

    fun setLineSpacing(spacing : F32) =>
        @sfText_setLineSpacing(_raw, spacing)
    
    fun setLetterSpacing(spacing : F32) =>
        @sfText_setLetterSpacing(_raw, spacing)

    fun setStyle(style : U32) =>
        @sfText_setStyle(_raw, style)

    fun setColor(color : SFColor) =>
        @sfText_setColor(_raw, color.u32())

    fun setFillColor(color : SFColor) =>
        @sfText_setFillColor(_raw, color.u32())

    fun setOutlineColor(color : SFColor) =>
        @sfText_setOutlineColor(_raw, color.u32())

    fun setOutlineThickness(thickness : F32) =>
        @sfText_setOutlineThickness(_raw, thickness)

    fun ref setPosition(position : SFVector2f) =>
        @sfText_setPosition(_raw, position.u64())

    fun ref setScale(factors : SFVector2f) =>
        @sfText_setScale(_raw, factors.u64())

    fun ref setOrigin(origin : SFVector2f) =>
        @sfText_setOrigin(_raw, origin.u64())
    
    fun ref setRotation(angle : F32) =>
        @sfText_setRotation(_raw, angle)

    fun ref getGlobalBounds() : SFFloatRect =>
        let rect = SFFloatRect.from_u128(0)
        if not _raw.is_none() then
            @sfText_getGlobalBoundsA(_raw, SFFloatRectRaw(rect))
            rect
        else
            rect
        end

    fun ref getLocalBounds() : SFFloatRect =>
        let rect = SFFloatRect.from_u128(0)
        if not _raw.is_none() then
            @sfText_getLocalBoundsA(_raw, SFFloatRectRaw(rect))
            rect
        else
            rect
        end

    fun ref getRaw() : SFTextRaw =>
        _raw

    fun ref isNULL() : Bool =>
        _raw.is_none()

    fun ref destroy() =>
        if not _raw.is_none() then
             @sfText_destroy(_raw)
            _raw = SFTextRaw.none()
        end

    fun _final() =>
        if not _raw.is_none() then @sfText_destroy(_raw) end

