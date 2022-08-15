use "buffered"
use "collections"

primitive EventType
    fun sfEvtClosed(): I32 =>                 0 // The window requested to be closed (no data)
    fun sfEvtResized(): I32 =>                1 // The window was resized (data in event.size)
    fun sfEvtLostFocus(): I32 =>              2 // The window lost the focus (no data)
    fun sfEvtGainedFocus(): I32 =>            3 // The window gained the focus (no data)
    fun sfEvtTextEntered(): I32 =>            4 // A character was entered (data in event.text)
    fun sfEvtKeyPressed(): I32 =>             5 // A key was pressed (data in event.key)
    fun sfEvtKeyReleased(): I32 =>            6 // A key was released (data in event.key)
    fun sfEvtMouseWheelMoved(): I32 =>        7 // The mouse wheel was scrolled (data in event.mouseWheel) (deprecated)
    fun sfEvtMouseWheelScrolled(): I32 =>     8 // The mouse wheel was scrolled (data in event.mouseWheelScroll)
    fun sfEvtMouseButtonPressed(): I32 =>     9 // A mouse button was pressed (data in event.mouseButton)
    fun sfEvtMouseButtonReleased(): I32 =>   10 // A mouse button was released (data in event.mouseButton)
    fun sfEvtMouseMoved(): I32 =>            11 // The mouse cursor moved (data in event.mouseMove)
    fun sfEvtMouseEntered(): I32 =>          12 // The mouse cursor entered the area of the window (no data)
    fun sfEvtMouseLeft(): I32 =>             13 // The mouse cursor left the area of the window (no data)
    fun sfEvtJoystickButtonPressed(): I32 => 14 // A joystick button was pressed (data in event.joystickButton)
    fun sfEvtJoystickButtonReleased(): I32 =>15 // A joystick button was released (data in event.joystickButton)
    fun sfEvtJoystickMoved(): I32 =>         16 // The joystick moved along an axis (data in event.joystickMove)
    fun sfEvtJoystickConnected(): I32 =>     17 // A joystick was connected (data in event.joystickConnect)
    fun sfEvtJoystickDisconnected(): I32 =>  18 // A joystick was disconnected (data in event.joystickConnect)
    fun sfEvtTouchBegan(): I32 =>            19 // A touch event began (data in event.touch)
    fun sfEvtTouchMoved(): I32 =>            20 // A touch moved (data in event.touch)
    fun sfEvtTouchEnded(): I32 =>            21 // A touch event ended (data in event.touch)
    fun sfEvtSensorChanged(): I32 =>         22 // A sensor value changed (data in event.sensor)
    fun sfEvtCount(): I32 =>                 23 // Keep last -- the total number of event types

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

type Event is (KeyEvent | WindowEvent | QuitEvent | None)

class EventStruct
    var array: Array[U8] val
    let reader: Reader
    let window: _RenderWindow

    new create(w: _RenderWindow) =>
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
