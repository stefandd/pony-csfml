//
// FFI declarations for CSFML functions
//
use @sfView_create[_ViewRaw]()
use @sfView_createFromRectA[_ViewRaw](left: F32, top: F32, width: F32, height: F32)
use @sfView_copy[_ViewRaw](view: _ViewRaw box)
use @sfView_destroy[None](view: _ViewRaw box)
use @sfView_setCenter[None](view: _ViewRaw box, center: _Vector2f)
use @sfView_setSize[None](view: _ViewRaw box, size: _Vector2f)
use @sfView_setRotation[None](view: _ViewRaw box, angle: F32)
use @sfView_setViewport[None](view: _ViewRaw box, viewport: U128)
use @sfView_resetA[None](view: _ViewRaw box, left: F32, top: F32, width: F32, height: F32)
use @sfView_getCenter[_Vector2f](view: _ViewRaw box)
use @sfView_getSize[_Vector2f](view: _ViewRaw box)
use @sfView_getRotation[F32](view: _ViewRaw box)
use @sfView_getViewport[U128](view: _ViewRaw box)
use @sfView_move[None](view: _ViewRaw box, offset: _Vector2f)
use @sfView_rotate[None](view: _ViewRaw box, angle: F32)
use @sfView_zoom[None](view: _ViewRaw box, factor: F32)

// 
// The CSFML object as seen by Pony
// Don't need to define its fields b/c we'll only be working with it as a ptr.
//
struct _View
type _ViewRaw is NullablePointer[_View]

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class View

  var _raw: _ViewRaw

  new create() =>
    _raw = @sfView_create()

  new createFromRect(rect: FloatRect) =>
    _raw = @sfView_createFromRectA(rect.left, rect.top, rect.width, rect.height)

  new createFromOrdinates(left: F32, top: F32, width: F32, height: F32) =>
    "This is a variation on the standard createFromRect(...), added by this Pony binding"
    _raw = @sfView_createFromRectA(left, top, width, height)

  fun copy(view: View) =>
    @sfView_copy(view._getRaw())
  
  //TODO: fun setCenter(center: Vector2f) =>
  //TODO: fun setSize(size: Vector2f) =>
  //TODO: fun setRotation(angle: F32) =>
  //TODO: fun setViewport(viewport: U128) =>
  
  fun reset(rect: FloatRect) =>
    @sfView_resetA(_raw, rect.left, rect.top, rect.width, rect.height)

  fun resetFromOrdinates(left: F32, top: F32, width: F32, height: F32) =>
    "This is a variation on the standard reset(...), added by this Pony binding"
    @sfView_resetA(_raw, left, top, width, height)
  
  //TODO: fun getCenter(): Vector2f =>
  //TODO: fun getSize(): Vector2f =>
  //TODO: fun getRotation(): F32 =>
  //TODO: fun getViewport(): ViewRect =>
  //TODO: fun move(offset: Vector2f) =>
  //TODO: fun rotate(angle: F32) =>
  //TODO: fun zoom(factor: F32) =>

  fun ref _getRaw(): _ViewRaw =>
    _raw

  fun \deprecated\ destroy() => 
      """ Because Pony has garbage collection, you don't need to call destroy() """
      None

  fun _final() =>
    if not _raw.is_none() then @sfView_destroy(_raw) end

