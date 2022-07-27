use @sfTransform_translate[None](transform: _TransformRaw box, x: F32, y: F32)


// CSFML FFI Object
//
// This only needs to match the memory layout of the corresponding CSFML concept.
// Its creators don't need to match the creators of the corresponding CSFML concept.

struct _Transform
    var a00: F32
    var a01: F32 
    var a02: F32
    var a10: F32 
    var a11: F32 
    var a12: F32
    var a20: F32 
    var a21: F32 
    var a22: F32

    new create(
        a00': F32 = 0, a01': F32 = 0, a02': F32 = 0,
        a10': F32 = 0, a11': F32 = 0, a12': F32 = 0,
        a20': F32 = 0, a21': F32 = 0, a22': F32 = 0)
    =>
        "Intended to be used with `where` to set just the non-zero elements."
        a00 = a00' ; a01 = a01' ; a02 = a02'
        a10 = a10' ; a11 = a11' ; a12 = a12'
        a20 = a20' ; a21 = a21' ; a22 = a22'

    new identity() =>
        a00 = 1 ; a01 = 0 ; a02 = 0
        a10 = 0 ; a11 = 1 ; a12 = 0
        a20 = 0 ; a21 = 0 ; a22 = 1

    new copy(that: _Transform) =>
        a00 = that.a00 ; a01 = that.a01 ; a02 = that.a02
        a10 = that.a10 ; a11 = that.a11 ; a12 = that.a12
        a20 = that.a20 ; a21 = that.a21 ; a22 = that.a22

    fun ref setFrom(that: _Transform) =>
        a00 = that.a00 ; a01 = that.a01 ; a02 = that.a02
        a10 = that.a10 ; a11 = that.a11 ; a12 = that.a12
        a20 = that.a20 ; a21 = that.a21 ; a22 = that.a22

type _TransformRaw is NullablePointer[_Transform]


// Pony Proxy Object
//
// The goal is for this class to look like the corresponding SFML C++ class, 
// as far as possible, so that existing SFML documentation will suffice.
// It should not (publicly) expose any FFI types.

class Transform

    let _struct: _Transform 

    new create() => 
        _struct = _Transform.identity()

    new fromFloats(
        a00: F32 = 0, a01: F32 = 0, a02: F32 = 0, 
        a10: F32 = 0, a11: F32 = 0, a12: F32 = 0, 
        a20: F32 = 0, a21: F32 = 0, a22: F32 = 0) 
    =>
        _struct = _Transform(a00, a01, a02, a10, a11, a12, a20, a21, a22)

    fun ref translate(x: F32, y: F32): Transform =>
        @sfTransform_translate(this._getRaw(), x, y)
        this

    new ref copy(that: Transform) =>
        _struct = _Transform.copy(that._struct)

    fun ref _getRaw(): _TransformRaw =>
        _TransformRaw(_struct)

    fun ref _getStruct(): _Transform =>
        _struct

