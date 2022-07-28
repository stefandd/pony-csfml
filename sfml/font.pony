// FFI declarations for CSFML functions
//
use @sfFont_createFromFile[FontRaw](filename : Pointer[U8 val] tag)
use @sfFont_destroy[None](font : FontRaw box)


// Because CSFML provides all the functions required to create and manipulate
// this structure (see 'use' statements, above), we don't need to define its
// fields. We'll only be working with it as a pointer.
//
struct _Font
type FontRaw is NullablePointer[_Font]


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
class Font
    var _raw : FontRaw

    new create(file : String) =>
        _raw = @sfFont_createFromFile(file.cstring())

    fun ref _getRaw(): FontRaw =>
        _raw

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfFont_destroy(_raw) end
