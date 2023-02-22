//
// FFI declarations for CSFML functions
//
use @sfView_create[NullablePointer[_View]]()
use @sfView_createFromRectA[NullablePointer[_View]](left: F32, top: F32, width: F32, height: F32)
use @sfView_copy[NullablePointer[_View]](view: _View box)
use @sfView_destroy[None](view: _View box)
use @sfView_setCenterA[None](view: _View box, center: _Packed[_Vector2f, U64])
use @sfView_setSizeA[None](view: _View box, size: _Packed[_Vector2f, U64])
use @sfView_setRotation[None](view: _View box, angle: F32)
use @sfView_setViewport[None](view: _View box, viewport: U128)
use @sfView_resetA[None](view: _View box, left: F32, top: F32, width: F32, height: F32)
use @sfView_getCenterA[_Packed[_Vector2f, U64]](view: _View box)
use @sfView_getSizeA[_Packed[_Vector2f, U64]](view: _View box)
use @sfView_getRotation[F32](view: _View box)
use @sfView_getViewport[U128](view: _View box)
use @sfView_moveA[None](view: _View box, offset: _Packed[_Vector2f,U64])
use @sfView_rotate[None](view: _View box, angle: F32)
use @sfView_zoom[None](view: _View box, factor: F32)

// 
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _View

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class View
  embed _temp_vec2f: _Vector2f = _Vector2f(0,0)
  var _csfml: _View
  var _this_created_csfml: Bool

  //
  // Public
  //

  new create()? =>
    _csfml = @sfView_create()()?
    _this_created_csfml = true

  new createFromRect(rect: FloatRect)? =>
    _csfml = @sfView_createFromRectA(
      rect.getLeft(), rect.getTop(), rect.getWidth(), rect.getHeight())()?
    _this_created_csfml = true

  new createFromOrdinates(left: F32, top: F32, width: F32, height: F32)? =>
    "This is a variation on the standard createFromRect(...), added by this Pony binding"
    _csfml = @sfView_createFromRectA(left, top, width, height)()?
    _this_created_csfml = true

  new copy(view: View)? =>
    _csfml = @sfView_copy(view._getCsfml())()?
    _this_created_csfml = true
  
  //TODO: fun setCenter(center: Vector2f) =>
  //TODO: fun setRotation(angle: F32) =>
  //TODO: fun setViewport(viewport: U128) =>
  
  fun reset(rect: FloatRect) =>
    @sfView_resetA(
      _csfml, 
      rect.getLeft(), rect.getTop(), rect.getWidth(), rect.getHeight())

  fun resetFromOrdinates(left: F32, top: F32, width: F32, height: F32) =>
    "This is a variation on the standard reset(...), added by this Pony binding"
    @sfView_resetA(_csfml, left, top, width, height)
  
  fun setSize(size: Vector2f) =>
    @sfView_setSizeA(_csfml, size._u64())

  fun ref setSizeFromFloats(width: F32, height: F32) =>
    _temp_vec2f.x = width
    _temp_vec2f.y = height
    @sfView_setSizeA(_csfml, _temp_vec2f.u64())

  //TODO: fun getCenter(): Vector2f =>
  //TODO: fun getSize(): Vector2f =>
  //TODO: fun getRotation(): F32 =>
  //TODO: fun getViewport(): ViewRect =>
  //TODO: fun move(offset: Vector2f) =>
  //TODO: fun rotate(angle: F32) =>
  //TODO: fun zoom(factor: F32) =>
  
  fun \deprecated\ destroy() => 
    """ Because Pony has garbage collection, you don't need to call destroy() """
    None

  //
  // Private
  //

  new _fromCsfml(csfml: _View) =>
    _csfml = csfml
    _this_created_csfml = false

  fun ref _getCsfml(): _View =>
    _csfml

  fun _final() =>
    if _this_created_csfml then @sfView_destroy(_csfml) end
