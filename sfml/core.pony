use "path:../shim library/"
use "lib:csfml-main" if windows
use "lib:csfml-system"
use "lib:csfml-window"
use "lib:csfml-graphics"
use "lib:csfml-audio"
use "lib:csfmlshim"
use "buffered"
use "collections"

// Context
use @sfContext_create[ContextRaw]()
use @sfContext_destroy[None](context: ContextRaw box)
use @sfContext_setActive[I32](context: ContextRaw, active: I32)
use @sfContext_getSettingsA[None](context: ContextRaw, settings: ContextSettingsRaw)
// Window
use @sfWindow_setActive[None](window: WindowRaw box, active: I32)
use @sfWindow_getSettingsA[None](window: WindowRaw box, sfContextsettings: ContextSettingsRaw)
// RenderWindow
use @sfRenderWindow_createA[RenderWindowRaw](width: U32, height: U32, bitsPerPixel: U32, name: Pointer[U8 val] tag, style: I32, sfContextsettings: ContextSettingsRaw)
use @sfRenderWindow_createUnicodeA[RenderWindowRaw](width: U32, height: U32, bitsPerPixel: U32, name: Pointer[U32 val] tag, style: I32, sfContextsettings: ContextSettingsRaw)
use @sfRenderWindow_setFramerateLimit[None](window: RenderWindowRaw box, limit: U32)
use @sfRenderWindow_getSettingsA[None](window: RenderWindowRaw box, sfContextsettings: ContextSettingsRaw)
use @sfRenderWindow_isOpen[I32](window: RenderWindowRaw box)
use @sfRenderWindow_hasFocus[I32](window: RenderWindowRaw box)
use @sfRenderWindow_setActive[I32](window: RenderWindowRaw box, active: I32)
use @sfRenderWindow_clear[None](window: RenderWindowRaw box, color: U32)
use @sfRenderWindow_display[None](window: RenderWindowRaw box)
use @sfRenderWindow_setView[None](window: RenderWindowRaw box, view: ViewRaw)
use @sfRenderWindow_drawSprite[None](window: RenderWindowRaw box, sprite: SpriteRaw, states: RenderStatesRaw)
use @sfRenderWindow_drawShape[None](window: RenderWindowRaw box, shape: ShapeRaw, states: RenderStatesRaw)
use @sfRenderWindow_drawText[None](window: RenderWindowRaw box, text: TextRaw, states: RenderStatesRaw)
use @sfRenderWindow_drawVertexArray[None](window: RenderWindowRaw box, vertexArray: VertexArrayRaw, states: RenderStatesRaw)
use @sfRenderWindow_pollEvent[I32](window: RenderWindowRaw box, event: Pointer[U8] tag)
use @sfRenderWindow_getSize[U64](window: RenderWindowRaw box)
use @sfRenderWindow_destroy[None](window: RenderWindowRaw box)
// RenderTexture
use @sfRenderTexture_create[RenderTextureRaw](width: U32, height: U32, depthBuffer: I32)
use @sfRenderTexture_clear[None](rendtex: RenderTextureRaw box, color: U32)
use @sfRenderTexture_display[None](rendtex: RenderTextureRaw box)
use @sfRenderTexture_drawSprite[None](rendtex: RenderTextureRaw box, sprite: SpriteRaw, states: RenderStatesRaw)
use @sfRenderTexture_getTexture[TextureRaw](rendtex: RenderTextureRaw box)
use @sfRenderTexture_drawShape[None](rendtex: RenderTextureRaw box, shape: ShapeRaw, states: RenderStatesRaw)
use @sfRenderTexture_drawText[None](rendtex: RenderTextureRaw box, text: TextRaw, states: RenderStatesRaw)
use @sfRenderTexture_destroy[None](rendtex: RenderTextureRaw box)
// Image
use @sfImage_create[ImageRaw](width: U32, height: U32)
use @sfImage_createFromColor[ImageRaw](width: U32, height: U32, color: U32)
use @sfImage_destroy[None](image: ImageRaw box)
// Texture
use @sfTexture_createFromFile[TextureRaw](filename: Pointer[U8 val] tag, area: IntRectRaw)
use @sfTexture_createFromImage[TextureRaw](image: ImageRaw box, area: IntRectRaw)
use @sfTexture_updateFromPixels[None](texture: TextureRaw, pixels: Pointer[U32] tag, width: U32, height: U32, x: U32, y: U32)
use @sfTexture_destroy[None](texture: TextureRaw box)
// Sprite
use @sfSprite_create[SpriteRaw]()
use @sfSprite_setTexture[None](sprite: SpriteRaw, texture: TextureRaw, resetRect: I32)
use @sfSprite_destroy[None](sprite: SpriteRaw box)
// Shader
use @sfShader_createFromMemory[ShaderRaw](vertexShader: Pointer[U8 val] tag, geometryShader: Pointer[U8 val] tag, fragmentShader: Pointer[U8 val] tag)
use @sfShader_setTextureParameter[None](shader: ShaderRaw box, name: Pointer[U8 val] tag, texture: TextureRaw)
use @sfShader_setFloatUniform[None](shader: ShaderRaw box, name: Pointer[U8 val] tag, x: F32)
use @sfShader_destroy[None](shader: ShaderRaw box)
// Keyboard
use @sfKeyboard_isKeyPressed[I32](key: I32)
// Sleep
use @sfSleep[None](duration: I64)
// Other
use @memcpy[Pointer[None]](dest: Pointer[None], src: Pointer[None] box, n: USize)

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

struct ContextSettings
    let depthBits: U32         ///< Bits of the depth buffer
    let stencilBits: U32       ///< Bits of the stencil buffer
    let antialiasingLevel: U32 ///< Level of antialiasing
    let majorVersion: U32      ///< Major number of the context version to create
    let minorVersion: U32      ///< Minor number of the context version to create
    let attributeFlags: U32    ///< The attribute flags to create the context with
    let sRgbCapable: I32      ///< Whether the context framebuffer is sRGB capable

    // TODO: Default args per https://www.sfml-dev.org/documentation/2.5.1/structsf_1_1ContextSettings.php
    new create(depth: U32, sbits: U32, aalev: U32, majver: U32, minver: U32, attr: U32, isRGB: I32) =>
        depthBits = depth
        stencilBits = sbits
        antialiasingLevel = aalev
        majorVersion = majver
        minorVersion = minver
        attributeFlags = attr
        sRgbCapable = isRGB

type ContextSettingsRaw is NullablePointer[ContextSettings]

primitive _Window
type WindowRaw is Pointer[_Window]

primitive _RenderWindow
type RenderWindowRaw is Pointer[_RenderWindow]

primitive _Context
type ContextRaw is Pointer[_Context]

struct _RenderTexture
type RenderTextureRaw is NullablePointer[_RenderTexture]

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
    let window: RenderWindowRaw

    new create(w: RenderWindowRaw) =>
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

// graphics object

struct _Sprite
type SpriteRaw is NullablePointer[_Sprite]

struct _Texture
type TextureRaw is NullablePointer[_Texture]

struct _Image
type ImageRaw is NullablePointer[_Image]

struct _Shader
type ShaderRaw is NullablePointer[_Shader]

struct Transform
    var matrix: Array[F32] = [1.0; 0; 0; 0; 1.0; 0; 0; 0; 1.0]

    new create(m: Array[F32] = [1.0; 0; 0; 0; 1.0; 0; 0; 0; 1.0]) =>
        matrix.clear()
        for i in Range(0, 9) do
            matrix.push(try m(i)? else 0.0 end)
        end

    fun ref getRaw(): TransformRaw =>
        matrix.cpointer()

type TransformRaw is Pointer[F32 val] tag

primitive BlendEquation
    fun sfBlendEquationAdd(): I32 => 0  ///< Pixel = Src * SrcFactor + Dst * DstFactor
    fun sfBlendEquationSubtract(): I32 => 1 ///< Pixel = Src * SrcFactor - Dst * DstFactor
    fun sfBlendEquationReverseSubtract(): I32 => 2  ///< Pixel = Dst * DstFactor - Src * SrcFactor

primitive BlendFactor
    fun sfBlendFactorZero(): I32 => 0              ///< (0, 0, 0, 0)
    fun sfBlendFactorOne(): I32 => 1               ///< (1, 1, 1, 1)
    fun sfBlendFactorSrcColor(): I32 => 2          
    fun sfBlendFactorOneMinusSrcColor(): I32 => 3  
    fun sfBlendFactorDstColor(): I32 => 4          
    fun sfBlendFactorOneMinusDstColor(): I32 => 5  
    fun sfBlendFactorSrcAlpha(): I32 => 6          
    fun sfBlendFactorOneMinusSrcAlpha(): I32 => 7  
    fun sfBlendFactorDstAlpha(): I32 => 8          
    fun sfBlendFactorOneMinusDstAlpha (): I32 => 9

struct BlendMode
    let colorSrcFactor: I32  ///< Source blending factor for the color channels
    let colorDstFactor: I32  ///< Destination blending factor for the color channels
    let colorEquation: I32   ///< Blending equation for the color channels
    let alphaSrcFactor: I32  ///< Source blending factor for the alpha channel
    let alphaDstFactor: I32  ///< Destination blending factor for the alpha channel
    let alphaEquation: I32   ///< Blending equation for the alpha channel

    new create(cSf: I32, cDf: I32, cE: I32, aSf: I32, aDf: I32, aE: I32) =>
        colorSrcFactor = cSf
        colorDstFactor = cDf
        colorEquation = cE
        alphaSrcFactor = aSf
        alphaDstFactor = aDf
        alphaEquation = aE

primitive StandardBlendModes
    fun sfBlendNone(): BlendMode =>
        BlendMode(
                    BlendFactor.sfBlendFactorOne(),
                    BlendFactor.sfBlendFactorZero(),
                    BlendEquation.sfBlendEquationAdd(),
                    BlendFactor.sfBlendFactorOne(),
                    BlendFactor.sfBlendFactorZero(),
                    BlendEquation.sfBlendEquationAdd()
                    )
    fun sfBlendAlpha(): BlendMode =>
        BlendMode(
                    BlendFactor.sfBlendFactorSrcAlpha(),
                    BlendFactor.sfBlendFactorOneMinusSrcAlpha(),
                    BlendEquation.sfBlendEquationAdd(),
                    BlendFactor.sfBlendFactorOne(),
                    BlendFactor.sfBlendFactorOneMinusSrcAlpha(),
                    BlendEquation.sfBlendEquationAdd()
                    )
    fun sfBlendAdd(): BlendMode =>
        BlendMode(
                    BlendFactor.sfBlendFactorSrcAlpha(),
                    BlendFactor.sfBlendFactorOne(),
                    BlendEquation.sfBlendEquationAdd(),
                    BlendFactor.sfBlendFactorOne(),
                    BlendFactor.sfBlendFactorOne(),
                    BlendEquation.sfBlendEquationAdd()
                    )
    fun sfBlendMultiply(): BlendMode =>
        BlendMode(
                    BlendFactor.sfBlendFactorDstColor(),
                    BlendFactor.sfBlendFactorZero(),
                    BlendEquation.sfBlendEquationAdd(),
                    BlendFactor.sfBlendFactorDstColor(),
                    BlendFactor.sfBlendFactorZero(),
                    BlendEquation.sfBlendEquationAdd()
                    )

type BlendModeRaw is NullablePointer[BlendMode]

struct RenderStates // this is originally a nested struct that cannot be passed out to C properly (the inner structs are not passed by value)
    var cSrc: I32    // therefore, this simply maps into a single monolithic struct that contains these structs in a single one.
    var cDst: I32
    var cEq: I32
    var aSrc: I32
    var aDst: I32
    var aEq: I32
    var a11: F32
    var a12: F32
    var a13: F32
    var a21: F32
    var a22: F32
    var a23: F32
    var a31: F32
    var a32: F32
    var a33: F32
    var texture: TextureRaw
    var shader: ShaderRaw

    new create(bm: BlendMode, tf: Transform, tex: Texture, sh: Shader) =>
        cSrc = bm.colorSrcFactor
        cDst = bm.colorDstFactor
        cEq = bm.colorEquation
        aSrc = bm.alphaSrcFactor
        aDst = bm.alphaDstFactor
        aEq = bm.alphaEquation
        a11 = try tf.matrix(0)? else 1.0 end
        a12 = try tf.matrix(1)? else 0.0 end
        a13 = try tf.matrix(2)? else 0.0 end
        a21 = try tf.matrix(3)? else 0.0 end
        a22 = try tf.matrix(4)? else 1.0 end
        a23 = try tf.matrix(5)? else 0.0 end
        a31 = try tf.matrix(6)? else 0.0 end
        a32 = try tf.matrix(7)? else 0.0 end
        a33 = try tf.matrix(8)? else 1.0 end
        texture = tex.getRaw()
        shader = sh.getRaw()

    fun ref getRaw(): RenderStatesRaw =>
        RenderStatesRaw(this)

    new default() =>
        cSrc = BlendFactor.sfBlendFactorSrcAlpha()
        cDst = BlendFactor.sfBlendFactorOneMinusSrcAlpha()
        cEq = BlendEquation.sfBlendEquationAdd()
        aSrc = BlendFactor.sfBlendFactorOne()
        aDst = BlendFactor.sfBlendFactorOneMinusSrcAlpha()
        aEq = BlendEquation.sfBlendEquationAdd()
        a11 = 1.0
        a12 = 0.0
        a13 = 0.0
        a21 = 0.0
        a22 = 1.0
        a23 = 0.0
        a31 = 0.0
        a32 = 0.0
        a33 = 1.0
        texture = TextureRaw.none()
        shader = ShaderRaw.none()

type RenderStatesRaw is NullablePointer[RenderStates]

// abstraction layer

// class RenderStates
//     var _raw: RenderStatesRaw ref
//
//     new create() =>
//         _raw = RenderStatesRaw(_RenderStates.default())
//
//     fun ref getRaw(): RenderStatesRaw =>
//         _raw

class Context
    var _raw: ContextRaw ref

    new create() =>
        _raw = @sfContext_create()

    fun ref getSettings(): ContextSettings =>
        var s: ContextSettings = ContextSettings.create(0, 0, 0, 0, 0, 0, 0)
        @sfContext_getSettingsA(_raw, ContextSettingsRaw(s))
        s

    fun ref setActive(active: Bool): Bool =>
        if active then
            @sfContext_setActive(_raw, 1) > 0
        else
            @sfContext_setActive(_raw, 0) > 0
        end

    fun ref destroy() =>
        if not _raw.is_null() then
            @sfContext_destroy(_raw)
            _raw = ContextRaw.create()
        end

    fun _final() =>
        if not _raw.is_null() then @sfContext_destroy(_raw) end

class RenderWindow
    var _raw: RenderWindowRaw ref
    let _evt: EventStruct

    new create(mode: VideoMode, title: String, style: I32, ctxsettings: ContextSettingsRaw = ContextSettingsRaw.none()) =>
        //let mode_arr: Array[U32] = [mode.width; mode.height; mode.bitsPerPixel] // trick to send this instead of the value struct
        //_raw = @sfRenderWindow_create(mode_arr.cpointer(), title.cstring(), style, ctxsettings)
        _raw = @sfRenderWindow_createA(mode.width, mode.height, mode.bitsPerPixel, title.cstring(), style, ctxsettings)
        _evt = EventStruct(_raw)

    fun ref getEventStruct(): EventStruct =>
        _evt
    
    fun ref getSettings(): ContextSettings =>
        var s: ContextSettings = ContextSettings.create(0, 0, 0, 0, 0, 0, 0)
        @sfRenderWindow_getSettingsA(_raw, ContextSettingsRaw(s))
        s

    fun ref setFramerateLimit(limit: U32) =>
        @sfRenderWindow_setFramerateLimit(_raw, limit)

    fun ref setActive(active: Bool): Bool =>
        if active then
            @sfRenderWindow_setActive(_raw, 1) > 0
        else
            @sfRenderWindow_setActive(_raw, 0) > 0
        end

    fun ref isOpen(): Bool =>
        @sfRenderWindow_isOpen(_raw) > 0

    fun ref hasFocus(): Bool =>
        @sfRenderWindow_hasFocus(_raw) > 0

    fun ref clear(color: Color = Color(0, 0, 0, 255)) =>
        @sfRenderWindow_clear(_raw, color._u32())

    fun ref drawSprite(sprite: Sprite, renderstate: RenderStatesRaw = RenderStatesRaw.none()) =>
        @sfRenderWindow_drawSprite(_raw, sprite.getRaw(), renderstate)

    // fun ref drawSprite(sprite: Sprite, renderstate: (RenderStates | None) = None) =>
    //     let renderStatesRaw: RenderStatesRaw = 
    //         match renderstate
    //             | None => RenderStatesRaw.none() 
    //             | let rs: RenderStates => rs.getRaw() 
    //         end
    //     @sfRenderWindow_drawSprite(_raw, sprite.getRaw(), renderStatesRaw)

    fun ref drawShape(shape: Shape, renderstate: RenderStatesRaw = RenderStatesRaw.none()) =>
        match shape
        | let s: CircleShape =>
            @sfRenderWindow_drawShape(_raw, s.getRaw(), renderstate)
        | let s: RectangleShape =>
            @sfRenderWindow_drawShape(_raw, s.getRaw(), renderstate)
        end

    fun ref drawText(text: Text, renderstate: RenderStatesRaw = RenderStatesRaw.none()) =>
        @sfRenderWindow_drawText(_raw, text.getRaw(), renderstate)

    fun ref drawVertexArray(vertexArray: VertexArray, states: RenderStatesRaw = RenderStatesRaw.none()) =>
        @sfRenderWindow_drawVertexArray(_raw, vertexArray.getRaw(), states)

    fun ref display() =>
        @sfRenderWindow_display(_raw)

    fun ref setView(view: View) =>
        @sfRenderWindow_setView(_raw, view.getRaw())

    fun ref destroy() =>
        if not _raw.is_null() then
            @sfRenderWindow_destroy(_raw)
            _raw = RenderWindowRaw.create()
        end

    fun _final() =>
        if not _raw.is_null() then @sfRenderWindow_destroy(_raw) end

class RenderTexture
    var _raw: RenderTextureRaw ref

    new create(width: U32, height: U32, depthBuffer: Bool) =>
        if depthBuffer then
            _raw = @sfRenderTexture_create(width, height, 1)
        else
            _raw = @sfRenderTexture_create(width, height, 0)
        end

    fun ref clear(color: Color) =>
        @sfRenderTexture_clear(_raw, color._u32())

    fun ref drawSprite(sprite: Sprite, renderstate: RenderStatesRaw = RenderStatesRaw.none()) =>
        @sfRenderTexture_drawSprite(_raw, sprite.getRaw(), renderstate)

    fun ref drawShape(shape: Shape, renderstate: RenderStatesRaw = RenderStatesRaw.none()) =>
        match shape
        | let s: CircleShape =>
            @sfRenderTexture_drawShape(_raw, s.getRaw(), renderstate)
        | let s: RectangleShape =>
            @sfRenderTexture_drawShape(_raw, s.getRaw(), renderstate)
        end

    fun ref drawText(text: Text, renderstate: RenderStatesRaw = RenderStatesRaw.none()) =>
        @sfRenderTexture_drawText(_raw, text.getRaw(), renderstate)

    fun ref getTextureRaw(): TextureRaw =>
        @sfRenderTexture_getTexture(_raw)

    fun ref display() =>
        @sfRenderTexture_display(_raw)

    fun ref isNULL(): Bool =>
        _raw.is_none()

    fun ref destroy() =>
        if not _raw.is_none() then
            @sfRenderTexture_destroy(_raw)
            _raw = RenderTextureRaw.none()
        end

    fun _final() =>
        if not _raw.is_none() then @sfRenderTexture_destroy(_raw) end

class Sprite
    var _raw: SpriteRaw ref

    new create() =>
        _raw = @sfSprite_create()

    fun ref setTexture(texture: Texture, resetRect: Bool = false) =>
        if resetRect then
            @sfSprite_setTexture(_raw, texture.getRaw(), 1)
        else
            @sfSprite_setTexture(_raw, texture.getRaw(), 0)
        end
    
    fun ref setTextureFromRaw(texptr: TextureRaw, resetRect: Bool = false) =>
        if resetRect then
            @sfSprite_setTexture(_raw, texptr, 1)
        else
            @sfSprite_setTexture(_raw, texptr, 0)
        end

    fun ref getRaw(): SpriteRaw =>
        _raw

    fun ref isNULL(): Bool =>
        _raw.is_none()

    fun ref destroy() =>
        if not _raw.is_none() then
             @sfSprite_destroy(_raw)
            _raw = SpriteRaw.none()
        end

    fun _final() =>
        if not _raw.is_none() then @sfSprite_destroy(_raw) end

class Texture
    var _raw: TextureRaw ref = TextureRaw.none()

    new create(tex_ptr: TextureRaw = TextureRaw.none()) =>
        _raw = tex_ptr

    new createFromFile(filename: String val, area: IntRectRaw = IntRectRaw.none()) =>
        _raw = @sfTexture_createFromFile(filename.cstring(), area)

    new ref createFromImage(image: Image, area: IntRectRaw = IntRectRaw.none()) =>
        _raw = @sfTexture_createFromImage(image.getRaw(), area)

    fun ref updateFromPixels(pixels: Pointer[U32] tag, width: U32, height: U32, x: U32, y: U32) =>
        @sfTexture_updateFromPixels(_raw, pixels, width, height, x, y)

    fun ref getRaw(): TextureRaw =>
        _raw

    fun ref isNULL(): Bool =>
        _raw.is_none()

    fun ref destroy() =>
        if not _raw.is_none() then
             @sfTexture_destroy(_raw)
            _raw = TextureRaw.none()
        end

    fun _final() =>
        if not _raw.is_none() then @sfTexture_destroy(_raw) end

class Image
    var _raw: ImageRaw ref

    new create(width: U32, height: U32) => 
        _raw = @sfImage_create(width, height)
    
    new createFromColor(width: U32, height: U32, color: Color) =>
        _raw = @sfImage_createFromColor(width, height, color._u32())

    fun ref getRaw(): ImageRaw =>
        _raw

    fun ref isNULL(): Bool =>
        _raw.is_none()

    fun ref destroy() =>
        if not _raw.is_none() then
             @sfImage_destroy(_raw)
            _raw = ImageRaw.none()
        end

    fun _final() =>
        if not _raw.is_none() then @sfImage_destroy(_raw) end

class Shader
    var _raw: ShaderRaw ref

    new createFromMemory(vertexShader: String val, geometryShader: String val, fragmentShader: String val) =>
        // create NULL pointers if the String argument is "" and cstrings otherwise
        let vsarg = if vertexShader.size() == 0 then Pointer[U8 val].create() else vertexShader.cstring() end
        let gsarg = if geometryShader.size() == 0 then Pointer[U8 val].create() else geometryShader.cstring() end
        let fsarg = if fragmentShader.size() == 0 then Pointer[U8 val].create() else fragmentShader.cstring() end
        _raw = @sfShader_createFromMemory(vsarg, gsarg, fsarg)

    fun ref setTextureParameter(name: String val, texture: TextureRaw) =>
        @sfShader_setTextureParameter(_raw, name.cstring(), texture)

    fun ref setFloatUniform(name: String val, floatval: F32) =>
        @sfShader_setFloatUniform(_raw, name.cstring(), floatval)

    fun ref getRaw(): ShaderRaw =>
        _raw

    fun ref isNULL(): Bool =>
        _raw.is_none()

    fun ref destroy() =>
        if not _raw.is_none() then
             @sfShader_destroy(_raw)
            _raw = ShaderRaw.none()
        end

    fun _final() =>
        if not _raw.is_none() then @sfShader_destroy(_raw) end

