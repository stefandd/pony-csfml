// 
// The SFML object as presented by CSFML
// 
type _Vector2f is _Vector2[F32]
type _Vector2u is _Vector2[U32]

struct _Vector2[T: (F32 | U32)]
    var x : T
    var y : T

    new create(x' : T, y' : T) =>
        x = x'
        y = y'

    new copy(that: _Vector2[T]) =>
        x = that.x
        y = that.y

    new setFrom(that: _Vector2[T]) =>
        x = that.x
        y = that.y

    // Pony structs can't be passed by value through Pony's FFI.
    // So for C funcs that expect structs by value we define a map to/from some unsigned int type.

    fun ref u64() : U64 =>
        var tmp : U64 = 0
        @memcpy(addressof tmp, NullablePointer[_Vector2[T]](this), USize(8))
        tmp

//
// Proxy classes that abstracts away CSFML and FFI and presents a clean Pony API.
//
type Vector2f is Vector2[F32]
type Vector2u is Vector2[U32]


class Vector2[T: (F32 | U32)]
    var _csfml: _Vector2[T]

    new create(x: T, y: T) => _csfml = _Vector2[T](x, y)

    new _fromCsfml(csfml: _Vector2[T]) =>
      _csfml = csfml

    fun ref _setCsfml(csfml: _Vector2[T]) =>
      _csfml = csfml

    fun getX(): T => _csfml.x
    fun getY(): T => _csfml.y

    fun ref _u64(): U64 => _csfml.u64()

    fun ref _getCsfml(): _Vector2[T] => _csfml

