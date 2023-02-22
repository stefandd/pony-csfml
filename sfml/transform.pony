//
// FFI declarations for CSFML functions
//
use @sfTransform_getMatrix[None](transform: _Transform, matrix: Pointer[F32])
use @sfTransform_getInverse[NullablePointer[_Transform]](transform: _Transform)
use @sfTransform_transformPoint[_Vector2f](transform: _Transform, point: _Vector2f)
use @sfTransform_transformRect[_FloatRect](transform: _Transform, rectangle: _FloatRect)
use @sfTransform_combine[None](transform: _Transform, other: _Transform)
use @sfTransform_translate[None](transform: _Transform box, x: F32, y: F32)
use @sfTransform_rotate[None](transform: _Transform, angle: F32)
use @sfTransform_rotateWithCenter[None](transform: _Transform, angle: F32, centerX: F32, centerY: F32)
use @sfTransform_scale[None](transform: _Transform, scaleX: F32, scaleY: F32)
use @sfTransform_scaleWithCenter[None](transform: _Transform, scaleX: F32, scaleY: F32, centerX: F32, centerY: F32)
use @sfTransform_equal[I32](left: _Transform, right: _Transform)
// use @sfTransform_fromMatrix <- We are not using this function.

// 
// The SFML object as presented by CSFML
// 
// Despite the fact that CSFML provides functions for creation and manipulation
// of Transforms, we are declaring the fields of _Transform here because an 
// EMBEDDED _Transform appears in _RenderStates.
//
// The only constraint on this private struct is that it needs to match the 
// memory layout of the corresponding CSFML concept. Its methods can be
// *anything* useful to the private implementation of pony-sfml.
//
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

    fun ref resetToIdentity() =>
        a00 = 1 ; a01 = 0 ; a02 = 0
        a10 = 0 ; a11 = 1 ; a12 = 0
        a20 = 0 ; a21 = 0 ; a22 = 1

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class Transform

    let _csfml: _Transform 

    new create() => 
        _csfml = _Transform.identity()

    new _fromCsfml(cptr: _Transform) => 
        _csfml = cptr

    new identity() => 
        _csfml = _Transform.identity()

    new fromMatrix(
        a00: F32 = 0, a01: F32 = 0, a02: F32 = 0, 
        a10: F32 = 0, a11: F32 = 0, a12: F32 = 0, 
        a20: F32 = 0, a21: F32 = 0, a22: F32 = 0) 
    =>
        _csfml = _Transform(a00, a01, a02, a10, a11, a12, a20, a21, a22)

    fun ref resetToIdentity(): Transform => 
        _csfml.resetToIdentity()
        this
    
    fun ref translate(x: F32, y: F32): Transform =>
        @sfTransform_translate(_csfml, x, y)
        this

    fun ref scale(x: F32, y: F32): Transform =>
        @sfTransform_scale(_csfml, x, y)
        this

    new ref copy(that: Transform) =>
        _csfml = _Transform.copy(that._csfml)

    fun ref _getCsfml(): _Transform =>
        _csfml

