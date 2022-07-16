use @sfView_create[SFViewRaw]()
use @sfView_createFromRectA[SFViewRaw](left: F32, top: F32, width: F32, height: F32)
use @sfView_copy[SFViewRaw](view: SFViewRaw box)
use @sfView_destroy[None](view: SFViewRaw box)
use @sfView_setCenter[None](view: SFViewRaw box, center: SFVector2f)
use @sfView_setSize[None](view: SFViewRaw box, size: SFVector2f)
use @sfView_setRotation[None](view: SFViewRaw box, angle: F32)
use @sfView_setViewport[None](view: SFViewRaw box, viewport: U128)
use @sfView_resetA[None](view: SFViewRaw box, left: F32, top: F32, width: F32, height: F32)
use @sfView_getCenter[SFVector2f](view: SFViewRaw box)
use @sfView_getSize[SFVector2f](view: SFViewRaw box)
use @sfView_getRotation[F32](view: SFViewRaw box)
use @sfView_getViewport[U128](view: SFViewRaw box)
use @sfView_move[None](view: SFViewRaw box, offset: SFVector2f)
use @sfView_rotate[None](view: SFViewRaw box, angle: F32)
use @sfView_zoom[None](view: SFViewRaw box, factor: F32)

struct _SFView
type SFViewRaw is NullablePointer[_SFView]

class SFView

  var _raw: SFViewRaw

  new create() =>
    _raw = @sfView_create()

  new createFromRect(rect: SFFloatRect) =>
    _raw = @sfView_createFromRectA(rect.left, rect.top, rect.width, rect.height)

  new createFromOrdinates(left: F32, top: F32, width: F32, height: F32) =>
    "This is a variation on the standard createFromRect(...), added by this Pony binding"
    _raw = @sfView_createFromRectA(left, top, width, height)

  fun copy(view: SFView) =>
    @sfView_copy(view.getRaw())
  
  fun ref destroy() =>
    if not _raw.is_none() then
       @sfView_destroy(_raw)
      _raw = SFViewRaw.none()
    end

  //TODO: fun setCenter(center: SFVector2f) =>
  //TODO: fun setSize(size: SFVector2f) =>
  //TODO: fun setRotation(angle: F32) =>
  //TODO: fun setViewport(viewport: U128) =>
  
  fun reset(rect: SFFloatRect) =>
    @sfView_resetA(_raw, rect.left, rect.top, rect.width, rect.height)

  fun resetFromOrdinates(left: F32, top: F32, width: F32, height: F32) =>
    "This is a variation on the standard reset(...), added by this Pony binding"
    @sfView_resetA(_raw, left, top, width, height)
  
  //TODO: fun getCenter(view: SFViewRaw): SFVector2f =>
  //TODO: fun getSize(view: SFViewRaw): SFVector2f =>
  //TODO: fun getRotation(view: SFViewRaw): F32 =>
  //TODO: fun getViewport(view: SFViewRaw): SFViewRect =>
  //TODO: fun move(offset: SFVector2f) =>
  //TODO: fun rotate(angle: F32) =>
  //TODO: fun zoom(factor: F32) =>

  fun ref getRaw(): SFViewRaw =>
    _raw

  fun ref isNULL(): Bool =>
    _raw.is_none()

  fun _final() =>
    if not _raw.is_none() then @sfView_destroy(_raw) end

