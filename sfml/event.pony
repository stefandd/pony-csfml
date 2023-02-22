use "buffered"
use "collections"

primitive EventType
    fun closed(): I32 =>                 0 // The window requested to be closed (no data)
    fun resized(): I32 =>                1 // The window was resized (data in event.size)
    fun lostFocus(): I32 =>              2 // The window lost the focus (no data)
    fun gainedFocus(): I32 =>            3 // The window gained the focus (no data)
    fun textEntered(): I32 =>            4 // A character was entered (data in event.text)
    fun keyPressed(): I32 =>             5 // A key was pressed (data in event.key)
    fun keyReleased(): I32 =>            6 // A key was released (data in event.key)
    fun mouseWheelMoved(): I32 =>        7 // The mouse wheel was scrolled (data in event.mouseWheel) (deprecated)
    fun mouseWheelScrolled(): I32 =>     8 // The mouse wheel was scrolled (data in event.mouseWheelScroll)
    fun mouseButtonPressed(): I32 =>     9 // A mouse button was pressed (data in event.mouseButton)
    fun mouseButtonReleased(): I32 =>   10 // A mouse button was released (data in event.mouseButton)
    fun mouseMoved(): I32 =>            11 // The mouse cursor moved (data in event.mouseMove)
    fun mouseEntered(): I32 =>          12 // The mouse cursor entered the area of the window (no data)
    fun mouseLeft(): I32 =>             13 // The mouse cursor left the area of the window (no data)
    fun joystickButtonPressed(): I32 => 14 // A joystick button was pressed (data in event.joystickButton)
    fun joystickButtonReleased(): I32 =>15 // A joystick button was released (data in event.joystickButton)
    fun joystickMoved(): I32 =>         16 // The joystick moved along an axis (data in event.joystickMove)
    fun joystickConnected(): I32 =>     17 // A joystick was connected (data in event.joystickConnect)
    fun joystickDisconnected(): I32 =>  18 // A joystick was disconnected (data in event.joystickConnect)
    fun touchBegan(): I32 =>            19 // A touch event began (data in event.touch)
    fun touchMoved(): I32 =>            20 // A touch moved (data in event.touch)
    fun touchEnded(): I32 =>            21 // A touch event ended (data in event.touch)
    fun sensorChanged(): I32 =>         22 // A sensor value changed (data in event.sensor)
    fun count(): I32 =>                 23 // Keep last -- the total number of event types

primitive QuitEvent
primitive MouseEnteredEvent
primitive MouseLeftEvent

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

type Event is 
    ( KeyEvent 
    | MouseEnteredEvent
    | MouseLeftEvent
    | QuitEvent
    | WindowEvent  
    | None
    )

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

            if (event_type == EventType.keyPressed()) or (event_type == EventType.keyReleased()) then
                KeyEvent( where
                    type'    = event_type,
                    code'    = reader.peek_i32_le(4)?,
                    alt'     = reader.peek_i32_le(8)?,
                    control' = reader.peek_i32_le(12)?,
                    shift'   = reader.peek_i32_le(16)?,
                    system'  = reader.peek_i32_le(20)?
                )

            elseif event_type == EventType.closed() then
                QuitEvent

            elseif event_type == EventType.mouseEntered() then
                MouseEnteredEvent

            elseif event_type == EventType.mouseLeft() then
                MouseLeftEvent

            elseif event_type == EventType.resized() then
                let newx: I32 = reader.peek_i32_le(4)?
                let newy: I32 = reader.peek_i32_le(8)?
                WindowEvent(true, false, false, newx, newy)

            elseif event_type == EventType.lostFocus() then
                WindowEvent(false, false, true)

            elseif event_type == EventType.gainedFocus() then
                WindowEvent(false, true, false)
            end

        else
            //@fprintf[I32](@pony_os_stdout[Pointer[U8]](), "Event handling error\n".cstring(), "".cstring())
            None
        end
