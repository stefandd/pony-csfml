use "path:../shim library/"
use "lib:csfml-main" if windows
use "lib:csfml-system"
use "lib:csfml-window"
use "lib:csfml-graphics"
use "lib:csfml-audio"
use "lib:csfmlshim"
use "buffered"
use "collections"

// Window
use @sfWindow_setActive[None](window: WindowRaw box, active: I32)
use @sfWindow_getSettingsA[None](window: WindowRaw box, settings: _ContextSettingsRaw)
// Keyboard
use @sfKeyboard_isKeyPressed[I32](key: I32)
// Sleep
use @sfSleep[None](duration: I64)
// Other
use @memcpy[Pointer[None]](dest: Pointer[None], src: Pointer[None] box, n: USize)


type Optional[X] is (X | None)


primitive System
    fun sleep(duration: I64) => @sfSleep(duration)

struct VideoMode
    let width: U32  ///< Video mode width, in pixels
    let height: U32 ///< Video mode height, in pixels
    let bitsPerPixel: U32 ///< Video mode pixel depth, in bits per pixels

    new create(w: U32, h: U32, depth: U32) =>
        width = w
        height = h
        bitsPerPixel = depth

type VideoModeRaw is NullablePointer[VideoMode]


primitive _Window
type WindowRaw is Pointer[_Window]

primitive WindowStyle
    fun sfNone(): I32         => 0      ///< No border / title bar (this flag and all others are mutually exclusive)
    fun sfTitlebar(): I32     => 1 << 0 ///< Title bar + fixed border
    fun sfResize(): I32       => 1 << 1 ///< Titlebar + resizable border + maximize button
    fun sfClose(): I32        => 1 << 2 ///< Titlebar + close button
    fun sfFullscreen(): I32   => 1 << 3 ///< Fullscreen mode (this flag and all others are mutually exclusive)
    fun sfDefaultStyle(): I32 => sfTitlebar() or sfResize() or sfClose() ///< Default window style

primitive EventType
    fun sfEvtClosed(): I32 =>                 0 ///< The window requested to be closed (no data)
    fun sfEvtResized(): I32 =>                1 ///< The window was resized (data in event.size)
    fun sfEvtLostFocus(): I32 =>              2 ///< The window lost the focus (no data)
    fun sfEvtGainedFocus(): I32 =>            3 ///< The window gained the focus (no data)
    fun sfEvtTextEntered(): I32 =>            4 ///< A character was entered (data in event.text)
    fun sfEvtKeyPressed(): I32 =>             5 ///< A key was pressed (data in event.key)
    fun sfEvtKeyReleased(): I32 =>            6 ///< A key was released (data in event.key)
    fun sfEvtMouseWheelMoved(): I32 =>        7 ///< The mouse wheel was scrolled (data in event.mouseWheel) (deprecated)
    fun sfEvtMouseWheelScrolled(): I32 =>     8 ///< The mouse wheel was scrolled (data in event.mouseWheelScroll)
    fun sfEvtMouseButtonPressed(): I32 =>     9 ///< A mouse button was pressed (data in event.mouseButton)
    fun sfEvtMouseButtonReleased(): I32 =>   10 ///< A mouse button was released (data in event.mouseButton)
    fun sfEvtMouseMoved(): I32 =>            11 ///< The mouse cursor moved (data in event.mouseMove)
    fun sfEvtMouseEntered(): I32 =>          12 ///< The mouse cursor entered the area of the window (no data)
    fun sfEvtMouseLeft(): I32 =>             13 ///< The mouse cursor left the area of the window (no data)
    fun sfEvtJoystickButtonPressed(): I32 => 14 ///< A joystick button was pressed (data in event.joystickButton)
    fun sfEvtJoystickButtonReleased(): I32 =>15 ///< A joystick button was released (data in event.joystickButton)
    fun sfEvtJoystickMoved(): I32 =>         16 ///< The joystick moved along an axis (data in event.joystickMove)
    fun sfEvtJoystickConnected(): I32 =>     17 ///< A joystick was connected (data in event.joystickConnect)
    fun sfEvtJoystickDisconnected(): I32 =>  18 ///< A joystick was disconnected (data in event.joystickConnect)
    fun sfEvtTouchBegan(): I32 =>            19 ///< A touch event began (data in event.touch)
    fun sfEvtTouchMoved(): I32 =>            20 ///< A touch moved (data in event.touch)
    fun sfEvtTouchEnded(): I32 =>            21 ///< A touch event ended (data in event.touch)
    fun sfEvtSensorChanged(): I32 =>         22 ///< A sensor value changed (data in event.sensor)
    fun sfEvtCount(): I32 =>                 23 ///< Keep last -- the total number of event types

primitive QuitEvent

class WindowEvent
    let resized: Bool
    let gainedfocus: Bool
    let lostfocus: Bool
    var newsizex: I32
    var newsizey: I32

    new create(rsz: Bool, gfoc: Bool, lfoc: Bool, newx: I32 = -1, newy: I32 = -1) =>
        resized = rsz
        gainedfocus = gfoc
        lostfocus = lfoc
        newsizex = newx
        newsizey = newy

class KeyEvent
    let eventtype: I32
    let code: I32  
    let alt: I32
    let control: I32
    let shift: I32
    let system: I32

    new create(type': I32, code': I32, alt': I32, control': I32, shift': I32, system': I32) =>
        eventtype = type'
        code = code'
        alt = alt'
        control = control'
        shift = shift'
        system = system'

primitive KeyBoard
    fun isKeyPressed(key: I32): Bool =>
        @sfKeyboard_isKeyPressed(key) > 0

primitive KeyCode
    fun sfKeyUnknown(): I32 => -1 ///< Unhandled key
    fun sfKeyA(): I32 =>  0         ///< The A key
    fun sfKeyB(): I32 =>  1         ///< The B key
    fun sfKeyC(): I32 =>  2         ///< The C key
    fun sfKeyD(): I32 =>  3         ///< The D key
    fun sfKeyE(): I32 =>  4         ///< The E key
    fun sfKeyF(): I32 =>  5         ///< The F key
    fun sfKeyG(): I32 =>  6         ///< The G key
    fun sfKeyH(): I32 =>  7         ///< The H key
    fun sfKeyI(): I32 =>  8         ///< The I key
    fun sfKeyJ(): I32 =>  9         ///< The J key
    fun sfKeyK(): I32 => 10         ///< The K key
    fun sfKeyL(): I32 => 11         ///< The L key
    fun sfKeyM(): I32 => 12         ///< The M key
    fun sfKeyN(): I32 => 13         ///< The N key
    fun sfKeyO(): I32 => 14         ///< The O key
    fun sfKeyP(): I32 => 15         ///< The P key
    fun sfKeyQ(): I32 => 16         ///< The Q key
    fun sfKeyR(): I32 => 17         ///< The R key
    fun sfKeyS(): I32 => 18         ///< The S key
    fun sfKeyT(): I32 => 19         ///< The T key
    fun sfKeyU(): I32 => 20         ///< The U key
    fun sfKeyV(): I32 => 21         ///< The V key
    fun sfKeyW(): I32 => 22         ///< The W key
    fun sfKeyX(): I32 => 23         ///< The X key
    fun sfKeyY(): I32 => 24         ///< The Y key
    fun sfKeyZ(): I32 => 25         ///< The Z key
    fun sfKeyNum0(): I32 => 26      ///< The 0 key
    fun sfKeyNum1(): I32 => 27      ///< The 1 key
    fun sfKeyNum2(): I32 => 28      ///< The 2 key
    fun sfKeyNum3(): I32 => 29      ///< The 3 key
    fun sfKeyNum4(): I32 => 30      ///< The 4 key
    fun sfKeyNum5(): I32 => 31      ///< The 5 key
    fun sfKeyNum6(): I32 => 32      ///< The 6 key
    fun sfKeyNum7(): I32 => 33      ///< The 7 key
    fun sfKeyNum8(): I32 => 34      ///< The 8 key
    fun sfKeyNum9(): I32 => 35      ///< The 9 key
    fun sfKeyEscape(): I32 => 36    ///< The Escape key
    fun sfKeyLControl(): I32 => 37  ///< The left Control key
    fun sfKeyLShift(): I32 => 38    ///< The left Shift key
    fun sfKeyLAlt(): I32 => 39      ///< The left Alt key
    fun sfKeyLSystem(): I32 => 40   ///< The left OS specific key: window (Windows and Linux)(): I32 => apple (MacOS X)(): I32 => ...
    fun sfKeyRControl(): I32 => 41  ///< The right Control key
    fun sfKeyRShift(): I32 => 42    ///< The right Shift key
    fun sfKeyRAlt(): I32 => 43      ///< The right Alt key
    fun sfKeyRSystem(): I32 => 44   ///< The right OS specific key: window (Windows and Linux)(): I32 => apple (MacOS X)(): I32 => ...
    fun sfKeyMenu(): I32 => 45      ///< The Menu key
    fun sfKeyLBracket(): I32 => 46  ///< The [ key
    fun sfKeyRBracket(): I32 => 47  ///< The ] key
    fun sfKeySemicolon(): I32 => 48 ///< The ; key
    fun sfKeyComma(): I32 => 49     ///< The (): I32 => key
    fun sfKeyPeriod(): I32 => 50    ///< The . key
    fun sfKeyQuote(): I32 => 51     ///< The ' key
    fun sfKeySlash(): I32 => 52     ///< The / key
    fun sfKeyBackslash(): I32 => 53 ///< The \ key
    fun sfKeyTilde(): I32 => 54     ///< The ~ key
    fun sfKeyEqual(): I32 => 55     ///< The = key
    fun sfKeyHyphen(): I32 => 56    ///< The - key (hyphen)
    fun sfKeySpace(): I32 => 57     ///< The Space key
    fun sfKeyEnter(): I32 => 58     ///< The Enter/Return key
    fun sfKeyBackspace(): I32 => 59 ///< The Backspace key
    fun sfKeyTab(): I32 => 60       ///< The Tabulation key
    fun sfKeyPageUp(): I32 => 61    ///< The Page up key
    fun sfKeyPageDown(): I32 => 62  ///< The Page down key
    fun sfKeyEnd(): I32 => 63       ///< The End key
    fun sfKeyHome(): I32 => 64      ///< The Home key
    fun sfKeyInsert(): I32 => 65    ///< The Insert key
    fun sfKeyDelete(): I32 => 66    ///< The Delete key
    fun sfKeyAdd(): I32 => 67       ///< The + key
    fun sfKeySubtract(): I32 => 68  ///< The - key (minus(): I32 => usually from numpad)
    fun sfKeyMultiply(): I32 => 69  ///< The * key
    fun sfKeyDivide(): I32 => 70    ///< The / key
    fun sfKeyLeft(): I32 => 71      ///< Left arrow
    fun sfKeyRight(): I32 => 72     ///< Right arrow
    fun sfKeyUp(): I32 => 73        ///< Up arrow
    fun sfKeyDown(): I32 => 74      ///< Down arrow
    fun sfKeyNumpad0(): I32 => 75   ///< The numpad 0 key
    fun sfKeyNumpad1(): I32 => 76   ///< The numpad 1 key
    fun sfKeyNumpad2(): I32 => 77   ///< The numpad 2 key
    fun sfKeyNumpad3(): I32 => 78   ///< The numpad 3 key
    fun sfKeyNumpad4(): I32 => 79   ///< The numpad 4 key
    fun sfKeyNumpad5(): I32 => 80   ///< The numpad 5 key
    fun sfKeyNumpad6(): I32 => 81   ///< The numpad 6 key
    fun sfKeyNumpad7(): I32 => 82   ///< The numpad 7 key
    fun sfKeyNumpad8(): I32 => 83   ///< The numpad 8 key
    fun sfKeyNumpad9(): I32 => 84   ///< The numpad 9 key
    fun sfKeyF1(): I32 => 85        ///< The F1 key
    fun sfKeyF2(): I32 => 86        ///< The F2 key
    fun sfKeyF3(): I32 => 87        ///< The F3 key
    fun sfKeyF4(): I32 => 88        ///< The F4 key
    fun sfKeyF5(): I32 => 89        ///< The F5 key
    fun sfKeyF6(): I32 => 90        ///< The F6 key
    fun sfKeyF7(): I32 => 91        ///< The F7 key
    fun sfKeyF8(): I32 => 92        ///< The F8 key
    fun sfKeyF9(): I32 => 93        ///< The F8 key
    fun sfKeyF10(): I32 => 94       ///< The F10 key
    fun sfKeyF11(): I32 => 95       ///< The F11 key
    fun sfKeyF12(): I32 => 96       ///< The F12 key
    fun sfKeyF13(): I32 => 97       ///< The F13 key
    fun sfKeyF14(): I32 => 98       ///< The F14 key
    fun sfKeyF15(): I32 => 99       ///< The F15 key
    fun sfKeyPause(): I32 => 100    ///< The Pause key
    fun sfKeyCount(): I32 => 101  ///< Keep last -- the total number of keyboard keys


type Event is (KeyEvent | WindowEvent | QuitEvent | None)

class EventStruct
    var array: Array[U8] val
    let reader: Reader
    let window: _RenderWindowRaw

    new create(w: _RenderWindowRaw) =>
        let array': Array[U8] iso = recover Array[U8]() end
        for i in Range(0, 32) do
            array'.push(0)
        end
        array = recover val consume array' end
        reader = Reader
        reader.append(array)
        window = w

    fun ref poll(): Bool =>
        @sfRenderWindow_pollEvent(window, array.cpointer()) != 0

    fun ref translate(): Event =>
        try
            let event_type: I32 = reader.peek_i32_le(0)?
            //@fprintf[I32](@pony_os_stdout[Pointer[U8]](), "Event Type: %s\n".cstring(), event_type.string().cstring())            
            if (event_type == EventType.sfEvtKeyPressed()) or (event_type == EventType.sfEvtKeyReleased()) then
                KeyEvent( where
                    type'    = event_type,
                    code'    = reader.peek_i32_le(4)?,
                    alt'     = reader.peek_i32_le(8)?,
                    control' = reader.peek_i32_le(12)?,
                    shift'   = reader.peek_i32_le(16)?,
                    system'  = reader.peek_i32_le(20)?
                )
            elseif event_type == EventType.sfEvtClosed() then
                QuitEvent
            elseif event_type == EventType.sfEvtResized() then
                let newx: I32 = reader.peek_i32_le(4)?
                let newy: I32 = reader.peek_i32_le(8)?
                WindowEvent(true, false, false, newx, newy)
            elseif event_type == EventType.sfEvtLostFocus() then
                WindowEvent(false, false, true)
            elseif event_type == EventType.sfEvtGainedFocus() then
                WindowEvent(false, true, false)
            end
        else
            //@fprintf[I32](@pony_os_stdout[Pointer[U8]](), "Event handling error\n".cstring(), "".cstring())
            None
        end
