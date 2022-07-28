use @sfFont_createFromFile[FontRaw](filename : Pointer[U8 val] tag)
use @sfFont_destroy[None](font : FontRaw box)

struct _Font
type FontRaw is NullablePointer[_Font]

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
