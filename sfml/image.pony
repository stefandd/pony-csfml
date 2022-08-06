//
// FFI declarations for CSFML functions
//
use @sfImage_create[_ImageRaw](width: U32, height: U32)
use @sfImage_createFromColor[_ImageRaw](width: U32, height: U32, color: U32)
use @sfImage_destroy[None](image: _ImageRaw box)

// 
// The SFML object as presented by CSFML
// Don't need to define its fields b/c we'll only be working with it as a ptr.
// 
struct _Image
type _ImageRaw is NullablePointer[_Image]


//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class Image
    var _raw: _ImageRaw ref

    new create(width: U32, height: U32) => 
        _raw = @sfImage_create(width, height)
    
    new createFromColor(width: U32, height: U32, color: Color) =>
        _raw = @sfImage_createFromColor(width, height, color._u32())

    fun ref _getRaw(): _ImageRaw =>
        _raw

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfImage_destroy(_raw) end

