
type _FloatRect is _Rect[F32]
type _IntRect is _Rect[U32]

struct _Rect[T: (Real[T] & (F32 | U32))]
    let left: T
    let top: T
    let width: T
    let height: T

    new create(left': T, top': T, width': T, height': T) =>
        left = left'
        top = top'
        width = width'
        height = height'

    // Pony structs can't be passed by value through Pony's FFI.
    // So for C funcs that expect structs by value we define a map to/from some unsigned int type.

    fun ref u128(): U128 =>
        var tmp: U128 = 0
        @memcpy(addressof tmp, NullablePointer[_Rect[T]](this), USize(16))
        tmp

    new from_u128(chunk: U128) =>
        let z = T.from[U8](0)
        left = z ; top = z ; width = z ; height = z
        var tmp: U128 = chunk
        @memcpy(NullablePointer[_Rect[T]](this), addressof tmp, USize(16))


type FloatRect is Rect[F32]
type IntRect is Rect[U32]


class Rect[T: (Real[T] & (F32 | U32))]
  let _csfml: _Rect[T]

  new create(left: T, top: T, width: T, height: T) =>
      _csfml = _Rect[T](left, top, width, height)

  fun getLeft(): T => _csfml.left
  fun getTop(): T => _csfml.top
  fun getWidth(): T => _csfml.width
  fun getHeight(): T => _csfml.height

  fun ref _u128(): U128 => 
    _csfml.u128()

  new _from_u128(chunk: U128) => 
    _csfml = _Rect[T].from_u128(chunk)

  fun ref _getCsfml(): _Rect[T] => _csfml

  fun string(): String =>
    ", ".join([
      _csfml.left.string()
      _csfml.top.string()
      _csfml.width.string()
      _csfml.height.string()  
    ].values())