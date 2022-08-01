// FFI declarations for CSFML functions
//
use @sfTexture_create[_TextureRaw](width: U32, height: U32)
use @sfTexture_createFromFile[_TextureRaw](filename: Pointer[U8 val] tag, area: IntRectRaw)
use @sfTexture_createFromImage[_TextureRaw](image: ImageRaw box, area: IntRectRaw)
use @sfTexture_copy[_TextureRaw](from: _TextureRaw box)
use @sfTexture_updateFromPixels[None](texture: _TextureRaw box, pixels: Pointer[U32] tag, width: U32, height: U32, x: U32, y: U32)
use @sfTexture_destroy[None](texture: _TextureRaw box)


// Because CSFML provides all the functions required to create and manipulate
// this structure (see 'use' statements, above), we don't need to define its
// fields. We'll only be working with it as a pointer.
//
struct _Texture
type _TextureRaw is NullablePointer[_Texture]


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
class Texture
    var _raw: _TextureRaw ref

    new _wrap(cptr: _TextureRaw ref) =>
        "This is only used internally, to wrap a texture cptr"
        _raw = cptr

    new none() =>
        _raw = _TextureRaw.none()
        
    new create(width: U32, height: U32) =>
        _raw = @sfTexture_create(width, height)

    new createFromFile(filename: String val, area: IntRectRaw = IntRectRaw.none()) =>
        _raw = @sfTexture_createFromFile(filename.cstring(), area)

    new createFromImage(image: Image, area: IntRectRaw = IntRectRaw.none()) =>
        _raw = @sfTexture_createFromImage(image._getRaw(), area)

    new copy(from: Texture) =>
        _raw = @sfTexture_copy(from._getRaw())

    fun ref updateFromPixels(pixels: Pointer[U32] tag, width: U32, height: U32, x: U32, y: U32) =>
        @sfTexture_updateFromPixels(_raw, pixels, width, height, x, y)

    fun ref _getRaw(): _TextureRaw =>
        _raw

    fun \deprecated\ ref destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfTexture_destroy(_raw) end

