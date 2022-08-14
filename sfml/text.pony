use "collections"

//
// FFI declarations for CSFML functions
//
use @sfText_create[NullablePointer[_Text]]()
use @sfText_setString[None](text: _Text box, str: Pointer[U8 val] tag)
use @sfText_setFont[None](text: _Text box, font: _Font box)
use @sfText_setCharacterSize[None](text: _Text box, size: U32)
use @sfText_setLineSpacing[None](text: _Text box, spacingFactor: F32)
use @sfText_setLetterSpacing[None](text: _Text box, spacingFactor: F32)
use @sfText_setStyle[None](text: _Text box, style: U32)
use @sfText_setColor[None](text: _Text box, color: U32)
use @sfText_setFillColor[None](text: _Text box, color: U32)
use @sfText_setOutlineColor[None](text: _Text box, color: U32)
use @sfText_setOutlineThickness[None](text: _Text box, thickness: F32)
use @sfText_setPositionA[None](text: _Text box, position: U64)
use @sfText_setScaleA[None](text: _Text box, factors: U64)
use @sfText_setOriginA[None](text: _Text box, origin: U64)
use @sfText_setRotation[None](text: _Text box, angle: F32)
use @sfText_getLocalBoundsA[None](text: _Text box, bounds: _FloatRect)
use @sfText_getGlobalBoundsA[None](text: _Text box, bounds: _FloatRect)
use @sfText_getStyle[U32](text: _Text box)
use @sfText_destroy[None](text: _Text box)

// 
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _Text

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class Text
    var _csfml: _Text

    new create()? =>
        _csfml = @sfText_create()()?

    fun setString(txt : String) =>
        @sfText_setString(_csfml, txt.cstring())

    fun setFont(font : Font) =>
        @sfText_setFont(_csfml, font._getCsfml())

    fun setCharacterSize(size : U32) =>
        @sfText_setCharacterSize(_csfml, size)

    fun setLineSpacing(spacing : F32) =>
        @sfText_setLineSpacing(_csfml, spacing)

    fun setLetterSpacing(spacing : F32) =>
        @sfText_setLetterSpacing(_csfml, spacing)

    fun setStyle(style: TextStyle) =>
        """
        This differs from SFML's documented API in that it sets a SINGLE style.
        Together with with addStyle() and removeStyle(), Pony-SFML provides 
        type-safe manipulation of text styles.
        """
        @sfText_setStyle(_csfml, style())

    fun addStyle(style: TextStyle) =>
        "This is not part of standard SFML. See setStyle for details."
        var styleFlags = @sfText_getStyle(_csfml)
        @sfText_setStyle(_csfml, styleFlags or style())

    fun removeStyle(style: TextStyle) =>
        "This is not part of standard SFML. See setStyle for details."
        var styleFlags = @sfText_getStyle(_csfml)
        @sfText_setStyle(_csfml, styleFlags and not(style()))

    fun setColor(color : Color) =>
        @sfText_setColor(_csfml, color._u32())

    fun setFillColor(color : Color) =>
        @sfText_setFillColor(_csfml, color._u32())

    fun setOutlineColor(color : Color) =>
        @sfText_setOutlineColor(_csfml, color._u32())

    fun setOutlineThickness(thickness : F32) =>
        @sfText_setOutlineThickness(_csfml, thickness)

    fun ref setPosition(position : Vector2f) =>
        @sfText_setPositionA(_csfml, position._u64())

    fun ref setScale(factors : Vector2f) =>
        @sfText_setScaleA(_csfml, factors._u64())

    fun ref setOrigin(origin : Vector2f) =>
        @sfText_setOriginA(_csfml, origin._u64())

    fun ref setRotation(angle : F32) =>
        @sfText_setRotation(_csfml, angle)

    fun ref getGlobalBounds() : FloatRect =>
        let rect = FloatRect._from_u128(0)
        @sfText_getGlobalBoundsA(_csfml, rect._getStruct())
        rect

    fun ref getLocalBounds() : FloatRect =>
        let rect = FloatRect._from_u128(0)
        @sfText_getLocalBoundsA(_csfml, rect._getStruct())
        rect

    fun ref _getCsfml(): _Text =>
        _csfml

    fun \deprecated\ destroy() =>
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        @sfText_destroy(_csfml)


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
