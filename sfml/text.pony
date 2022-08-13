use "collections"

//
// FFI declarations for CSFML functions
//
use @sfText_create[_TextRaw]()
use @sfText_setString[None](text : _TextRaw box, str : Pointer[U8 val] tag)
use @sfText_setFont[None](text : _TextRaw box, font : _FontRaw box)
use @sfText_setCharacterSize[None](text : _TextRaw box, size : U32)
use @sfText_setLineSpacing[None](text : _TextRaw box, spacingFactor : F32)
use @sfText_setLetterSpacing[None](text : _TextRaw box, spacingFactor : F32)
use @sfText_setStyle[None](text : _TextRaw box, style : U32)
use @sfText_setColor[None](text : _TextRaw box, color : U32)
use @sfText_setFillColor[None](text : _TextRaw box, color : U32)
use @sfText_setOutlineColor[None](text : _TextRaw box, color : U32)
use @sfText_setOutlineThickness[None](text : _TextRaw box, thickness : F32)
use @sfText_setPositionA[None](text : _TextRaw box, position : U64)
use @sfText_setScaleA[None](text : _TextRaw box, factors : U64)
use @sfText_setOriginA[None](text : _TextRaw box, origin : U64)
use @sfText_setRotation[None](text : _TextRaw box, angle : F32)
use @sfText_getLocalBoundsA[None](text: _TextRaw box, bounds: _FloatRect)
use @sfText_getGlobalBoundsA[None](text: _TextRaw box, bounds: _FloatRect)
use @sfText_getStyle[U32](text : _TextRaw box)
use @sfText_destroy[None](text : _TextRaw box)

// 
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _Text
type _TextRaw is NullablePointer[_Text]

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class Text
    var _raw : _TextRaw

    new create()? =>
        _raw = @sfText_create()
        if _raw.is_none() then error end

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

    fun setStyle(style: TextStyle) =>
        """
        This differs from SFML's documented API in that it sets a SINGLE style.
        Together with with addStyle() and removeStyle(), Pony-SFML provides 
        type-safe manipulation of text styles.
        """
        @sfText_setStyle(_raw, style())

    fun addStyle(style: TextStyle) =>
        "This is not part of standard SFML. See setStyle for details."
        var styleFlags = @sfText_getStyle(_raw)
        @sfText_setStyle(_raw, styleFlags or style())

    fun removeStyle(style: TextStyle) =>
        "This is not part of standard SFML. See setStyle for details."
        var styleFlags = @sfText_getStyle(_raw)
        @sfText_setStyle(_raw, styleFlags and not(style()))

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
        @sfText_getGlobalBoundsA(_raw, rect._getStruct())
        rect

    fun ref getLocalBounds() : FloatRect =>
        let rect = FloatRect._from_u128(0)
        @sfText_getLocalBoundsA(_raw, rect._getStruct())
        rect

    fun ref _getRaw(): _TextRaw =>
        _raw

    fun \deprecated\ destroy() =>
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfText_destroy(_raw) end


primitive TextRegular       fun apply(): U32 => 0
primitive TextBold          fun apply(): U32 => 1 << 0
primitive TextItalic        fun apply(): U32 => 1 << 1
primitive TextUnderlined    fun apply(): U32 => 1 << 2
primitive TextStrikeThrough fun apply(): U32 => 1 << 3

type TextStyle is
    ( TextRegular
    | TextBold
    | TextItalic
    | TextUnderlined
    | TextStrikeThrough )
