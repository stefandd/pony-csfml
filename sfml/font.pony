//
// FFI declarations for CSFML functions
//
use @sfFont_createFromFile[_FontRaw](filename : Pointer[U8 val] tag)
use @sfFont_destroy[None](font : _FontRaw box)

// 
// The SFML object as presented by CSFML
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _Font
type _FontRaw is Pointer[_Font]

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class Font
    var _raw : _FontRaw

    new create(file : String) =>
        _raw = @sfFont_createFromFile(file.cstring())

    fun ref _getRaw(): _FontRaw =>
        _raw

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_null() then @sfFont_destroy(_raw) end
