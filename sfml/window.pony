// use @sfWindow_setActive[None](window: _Window box, active: I32)
// use @sfWindow_getSettingsA[None](window: _Window box, settings: _ContextSettings)
use "debug"

struct _Window

// class Window
//   let _window: _Window
// 
//   new create() =>
//     _window = _Window

class WindowStyle
  """
  A class that allows for safe combination of window styles. For example, 
  WindowStyle.titlebar().close().fullscreen() is invalid and generates
  a debug message. But WindowStyle.titlebar().close() is valid, as is 
  WindowStyle.fullscreen(), etc.
  """
  var _undefined: I32  = -1 // This is semantically different than _none
  let _none: I32       = 0
  let _titlebar: I32   = 1 << 0
  let _resize: I32     = 1 << 1
  let _close: I32      = 1 << 2
  let _fullscreen: I32 = 1 << 3
  let _default: I32    = _titlebar + _resize + _close 
  var _code: I32       = _undefined
  let _errmsg: String  = "Error: You have attempted to combine incompatible window style options."

  fun ref _exclusive(option: I32) =>
    if (_code == _undefined) or (_code == option) then 
      _code = option
    else
      Debug(_errmsg)
    end

  fun ref _add(option: I32) =>
    if (_code != _none) and (_code != _fullscreen) then
      _code = option + if _code == _undefined then 0 else _code end
    else
      Debug(_errmsg)
    end

  fun ref none(): WindowStyle =>
    "No border / title bar (this option cannot be combined with others)"
    _exclusive(_none)
    this

  fun ref titlebar(): WindowStyle => 
    "Titlebar + fixed border"
    _add(_titlebar)
    this

  fun ref resize(): WindowStyle =>
    "Titlebar + resizable border + maximize button"
    _add(_resize)
    this

  fun ref close(): WindowStyle =>
    "Titlebar + close button"
    _add(_close)
    this

  fun ref fullscreen(): WindowStyle => 
    "Fullscreen mode (this option cannot be combined with others)"
    _exclusive(_fullscreen)
    this

  fun ref default(): WindowStyle => 
    "Titlebar + resizable border + close button"
    _add(_titlebar) ; _add(_resize) ; _add(_close)
    this

  fun _i32(): I32 => 
    _code