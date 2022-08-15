use @sfWindow_setActive[None](window: WindowRaw box, active: I32)
use @sfWindow_getSettingsA[None](window: WindowRaw box, settings: _ContextSettings)


primitive _Window
type WindowRaw is Pointer[_Window]

primitive WindowStyle
    fun sfNone(): I32         => 0      ///< No border / title bar (this flag and all others are mutually exclusive)
    fun sfTitlebar(): I32     => 1 << 0 ///< Title bar + fixed border
    fun sfResize(): I32       => 1 << 1 ///< Titlebar + resizable border + maximize button
    fun sfClose(): I32        => 1 << 2 ///< Titlebar + close button
    fun sfFullscreen(): I32   => 1 << 3 ///< Fullscreen mode (this flag and all others are mutually exclusive)
    fun sfDefaultStyle(): I32 => sfTitlebar() or sfResize() or sfClose() ///< Default window style
