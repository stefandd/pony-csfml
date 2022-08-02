use @sfImage_create[ImageRaw](width: U32, height: U32)
use @sfImage_createFromColor[ImageRaw](width: U32, height: U32, color: U32)
use @sfImage_destroy[None](image: ImageRaw box)


struct _Image
type ImageRaw is NullablePointer[_Image]


class Image
    var _raw: ImageRaw ref

    new create(width: U32, height: U32) => 
        _raw = @sfImage_create(width, height)
    
    new createFromColor(width: U32, height: U32, color: Color) =>
        _raw = @sfImage_createFromColor(width, height, color._u32())

    fun ref _getRaw(): ImageRaw =>
        _raw

    fun \deprecated\ destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfImage_destroy(_raw) end

