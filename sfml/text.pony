use "collections"
use "debug"

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
use @sfText_getLocalBoundsA[None](text : _TextRaw box, bounds : FloatRectRaw)
use @sfText_getGlobalBoundsA[None](text : _TextRaw box, bounds : FloatRectRaw)
use @sfText_destroy[None](text : _TextRaw box)


// Because CSFML provides all the functions required to create and manipulate
// this structure (see 'use' statements, above), we don't need to define its
// fields. We'll only be working with it as a pointer.
//
struct _Text
type _TextRaw is NullablePointer[_Text]


// Pony Proxy Class
//
// The goal for this class to be a Pony proxy for the corresponding SFML 
// C++ class. As far as is possible, given the differences between Pony
// and C++, this class should be identical to the corresponding C++ class.
// This will make it easy for users of pony-sfml to understand existing
// SFML docs and examples.
//
// This class must not publicly expose any FFI types.
//
class Text
    var _raw : _TextRaw

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

    fun setStyle(style: (TextStyle | Array[TextStyle])) =>
        """
        In SFML's C++ documentation, you'll see styles combined by OR'ing them
        together. In pony-sfml, styles are combined by grouping them in an array.
        """
        let styleU32 = match style
            | let s: TextStyle => 
                s._u32()
            | let a: Array[TextStyle] =>
                let styleList = List[TextStyle].from(a)
                let folder = { (total:U32, s:TextStyle): U32 => total + s._u32() }
                styleList.fold[U32](folder, 0)
            end
        @sfText_setStyle(_raw, styleU32)

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

    fun ref _getRaw(): _TextRaw =>
        _raw

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfText_destroy(_raw) end


trait val TextStyle
    fun _u32(): U32 // For CSFML FFI

// These primitives improve type-safety vs SFML's U32 approach.
primitive TextRegular is TextStyle       fun _u32(): U32 => 0      
primitive TextBold is TextStyle          fun _u32(): U32 => 1 << 0 
primitive TextItalic is TextStyle        fun _u32(): U32 => 1 << 1 
primitive TextUnderlined is TextStyle    fun _u32(): U32 => 1 << 2 
primitive TextStrikeThrough is TextStyle fun _u32(): U32 => 1 << 3 

// Example of C++/Pony correlation for combined text styles:
// C++:  text.setStyle(sf::Text::Bold | sf::Text::Underlined);
// Pony: text.setStyle([sf.TextBold ; sf.TextUnderlined])
