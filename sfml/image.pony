//
// FFI declarations for CSFML functions
//
use @sfImage_create[NullablePointer[_Image]](width: U32, height: U32)
use @sfImage_createFromColor[NullablePointer[_Image]](width: U32, height: U32, color: U32)
use @sfImage_destroy[None](image: _Image box)

// 
// The SFML object as presented by CSFML
// Don't need to define its fields b/c we'll only be working with it as a ptr.
// 
struct _Image

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class Image
    var _csfml: _Image ref

    new create(width: U32, height: U32)? => 
        _csfml = @sfImage_create(width, height)()?
    
    new createFromColor(width: U32, height: U32, color: Color)? =>
        _csfml = @sfImage_createFromColor(width, height, color._u32())()?

    fun ref _getCsfml(): _Image =>
        _csfml

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        @sfImage_destroy(_csfml)

