//
// FFI declarations for CSFML functions
//
use @sfFont_createFromFile[NullablePointer[_Font]](filename: Pointer[U8 val] tag)
use @sfFont_destroy[None](font: _Font box)

// 
// The SFML object as presented by CSFML
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _Font

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class Font
    var _csfml: _Font

    new create(file: String)? =>
        _csfml = @sfFont_createFromFile(file.cstring())()?

    fun ref _getCsfml(): _Font =>
        _csfml

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        @sfFont_destroy(_csfml)
