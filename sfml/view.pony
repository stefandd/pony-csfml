use @sfView_create[ViewRaw]()
use @sfView_createFromRectA[ViewRaw](left: F32, top: F32, width: F32, height: F32)
use @sfView_copy[ViewRaw](view: ViewRaw box)
use @sfView_destroy[None](view: ViewRaw box)
use @sfView_setCenter[None](view: ViewRaw box, center: Vector2f)
use @sfView_setSize[None](view: ViewRaw box, size: Vector2f)
use @sfView_setRotation[None](view: ViewRaw box, angle: F32)
use @sfView_setViewport[None](view: ViewRaw box, viewport: U128)
use @sfView_resetA[None](view: ViewRaw box, left: F32, top: F32, width: F32, height: F32)
use @sfView_getCenter[Vector2f](view: ViewRaw box)
use @sfView_getSize[Vector2f](view: ViewRaw box)
use @sfView_getRotation[F32](view: ViewRaw box)
use @sfView_getViewport[U128](view: ViewRaw box)
use @sfView_move[None](view: ViewRaw box, offset: Vector2f)
use @sfView_rotate[None](view: ViewRaw box, angle: F32)
use @sfView_zoom[None](view: ViewRaw box, factor: F32)

struct _View
type ViewRaw is NullablePointer[_View]

class View

  var _raw: ViewRaw

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
  
  //TODO: fun getCenter(view: ViewRaw): Vector2f =>
  //TODO: fun getSize(view: ViewRaw): Vector2f =>
  //TODO: fun getRotation(view: ViewRaw): F32 =>
  //TODO: fun getViewport(view: ViewRaw): ViewRect =>
  //TODO: fun move(offset: Vector2f) =>
  //TODO: fun rotate(angle: F32) =>
  //TODO: fun zoom(factor: F32) =>

  fun ref _getRaw(): ViewRaw =>
    _raw

  fun \deprecated\ destroy() => 
      """ Because Pony has garbage collection, you don't need to call destroy() """
      None

  fun _final() =>
    if not _raw.is_none() then @sfView_destroy(_raw) end

