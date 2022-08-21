//
// FFI declarations for CSFML functions
//
use @sfTexture_create[NullablePointer[_Texture]](width: U32, height: U32)
use @sfTexture_createFromFile[NullablePointer[_Texture]](filename: Pointer[U8 val] tag, area: NullablePointer[_IntRect])
use @sfTexture_createFromImage[NullablePointer[_Texture]](image: _Image box, area: NullablePointer[_IntRect])
use @sfTexture_copy[NullablePointer[_Texture]](from: _Texture box)
use @sfTexture_updateFromPixels[None](texture: _Texture box, pixels: Pointer[U32] tag, width: U32, height: U32, x: U32, y: U32)
use @sfTexture_destroy[None](texture: _Texture box)

// 
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _Texture

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class Texture
    var _csfml: _Texture

    new _fromCsfml(t: _Texture ref) =>
        _csfml = t
        
    new create(width: U32, height: U32)? =>
        _csfml = @sfTexture_create(width, height)()?

    new createFromFile(filename: String val, area: Optional[IntRect] = None)? =>
        let area' = match area
        | None => NullablePointer[_IntRect].none()
        | let x: IntRect => NullablePointer[_IntRect](x._getCsfml())
        end
        _csfml = @sfTexture_createFromFile(filename.cstring(), area')()?

    new createFromImage(image: Image, area: Optional[IntRect] = None)? =>
        let area' = match area
        | None => NullablePointer[_IntRect].none()
        | let x: IntRect => NullablePointer[_IntRect](x._getCsfml())
        end
        _csfml = @sfTexture_createFromImage(image._getCsfml(), area')()?

    new copy(from: Texture)? =>
        _csfml = @sfTexture_copy(from._getCsfml())()?

    fun ref updateFromPixels(pixels: Pointer[U32] tag, width: U32, height: U32, x: U32, y: U32) =>
        @sfTexture_updateFromPixels(_csfml, pixels, width, height, x, y)

    fun ref _getCsfml(): _Texture =>
        _csfml

    fun \deprecated\ ref destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        @sfTexture_destroy(_csfml)

