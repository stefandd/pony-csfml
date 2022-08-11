struct IntRect
    let left : I32
    let top : I32
    let width : I32
    let height : I32

    new create(left' : I32, top' : I32, width' : I32, height' : I32) =>
        left = left'
        top = top'
        width = width'
        height = height'

    // Pony structs can't be passed by value through Pony's FFI.
    // So for C funcs that expect structs by value we define a map to/from some unsigned int type.

    fun ref _u128() : U128 =>
        var tmp : U128 = 0
        @memcpy(addressof tmp, IntRectRaw(this), USize(16))
        tmp

type IntRectRaw is NullablePointer[IntRect]

struct FloatRect
    let left : F32
    let top : F32
    let width : F32
    let height : F32

    new create(left' : F32, top' : F32, width' : F32, height' : F32) =>
        left = left'
        top = top'
        width = width'
        height = height'

    // Pony structs can't be passed by value through Pony's FFI.
    // So for C funcs that expect structs by value we define a map to/from some unsigned int type.

    fun ref _u128() : U128 =>
        var tmp : U128 = 0
        @memcpy(addressof tmp, FloatRectRaw(this), USize(16))
        tmp

    new _from_u128(chunk : U128) =>
        left = 0; top = 0; width = 0; height = 0
        var tmp : U128 = chunk
        @memcpy(FloatRectRaw(this), addressof tmp, USize(16))

type FloatRectRaw is NullablePointer[FloatRect]
