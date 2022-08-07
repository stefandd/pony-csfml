//
// FFI declarations for CSFML functions
//
use @sfTexture_create[_TextureRaw](width: U32, height: U32)
use @sfTexture_createFromFile[_TextureRaw](filename: Pointer[U8 val] tag, area: IntRectRaw)
use @sfTexture_createFromImage[_TextureRaw](image: _ImageRaw box, area: IntRectRaw)
use @sfTexture_copy[_TextureRaw](from: _TextureRaw box)
use @sfTexture_updateFromPixels[None](texture: _TextureRaw box, pixels: Pointer[U32] tag, width: U32, height: U32, x: U32, y: U32)
use @sfTexture_destroy[None](texture: _TextureRaw box)

// 
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _Texture
type _TextureRaw is NullablePointer[_Texture]

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class Texture
    var _raw: _TextureRaw ref

    new _wrap(cptr: _TextureRaw ref) =>
        "This is only used internally, to wrap a texture cptr"
        _raw = cptr

    new none() => // TODO: This method should probably be deleted
        _raw = _TextureRaw.none() 
        
    new create(width: U32, height: U32)? =>
        _raw = @sfTexture_create(width, height)
        if _raw.is_none() then error end

    new createFromFile(filename: String val, area: IntRectRaw = IntRectRaw.none())? =>
        _raw = @sfTexture_createFromFile(filename.cstring(), area)
        if _raw.is_none() then error end

    new createFromImage(image: Image, area: IntRectRaw = IntRectRaw.none())? =>
        _raw = @sfTexture_createFromImage(image._getRaw(), area)
        if _raw.is_none() then error end

    new copy(from: Texture)? =>
        _raw = @sfTexture_copy(from._getRaw())
        if _raw.is_none() then error end

    fun ref updateFromPixels(pixels: Pointer[U32] tag, width: U32, height: U32, x: U32, y: U32) =>
        @sfTexture_updateFromPixels(_raw, pixels, width, height, x, y)

    fun ref _getRaw(): _TextureRaw =>
        _raw

    fun \deprecated\ ref destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfTexture_destroy(_raw) end

