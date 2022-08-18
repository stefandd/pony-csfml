
use "../../sfml"
use "time"
use "random"
use "collections"
use "debug"

class NotifyBehavior is TimerNotify
  let _be: {(Timer, U64)} val
  new iso create(be': {(Timer, U64)} val) => _be = consume be'
  fun apply(timer: Timer, count: U64): Bool => _be(timer, count) ; true

actor DemoActor
  let env: Env
  let window: RenderWindow
  let event: EventStruct
  let vtx_arr: VertexArray
  let circle: Shape
  let fps_font: Font
  let fps_text: Text
  let width: USize
  let height: USize
  var frames: U32 = 0
  var t_last_fps_frame: U64 = 0
  var t_last_circle_frame: U64 = 0
  var running: Bool = true
  let vtx_render_states: RenderStates = RenderStates.from(BlendMode.multiply())
  let timers: Timers = Timers
  let color_gray: Color = Color(127,127,127)
  let color_red: Color = Color.red()
  let wobble_rate: F32

  new create(
    env': Env,
    w': USize,
    h': USize,
    wobl: F32,
    rwin: RenderWindow iso,
    vtxa: VertexArray iso,
    circ: CircleShape iso,
    font: Font iso,
    text: Text iso )
  =>
    env = env'
    width = w'
    height = h'
    wobble_rate = wobl
    window = consume rwin
    vtx_arr = consume vtxa
    circle = consume circ
    fps_font = consume font
    fps_text = consume text

    window.setActive(true)

    event = window.getEventStruct()

    let w = width.f32()
    let h = height.f32()
    let half_w = w / 2
    let half_h = h / 2

    let thickness: F32 = 1
    let wobble: F32 = 10
    let r = half_w.min(half_h) - thickness - wobble
    circle
      .> setRadius(r)
      .> setFillColor(Color(127,200,127))
      .> setOutlineColor(Color.black())
      .> setOutlineThickness(thickness)
      .> setPosition(Vector2f(half_w, half_h))
      .> setOrigin(Vector2f(r, r-wobble))

    let vtx = { box (x: F32, y: F32): Vertex => Vertex(Vector2f(x, y), Color.red()) }
    let vertices = [vtx(0, 0) ; vtx(w, h) ; vtx(0, h) ; vtx(w, 0)]
    vtx_arr.setPrimitiveType(Lines)
    for v in vertices.values() do vtx_arr.append(v) end

    let font_size: U32 = 24
    fps_text
      .> setFont(fps_font)
      .> setCharacterSize(font_size)
      .> setOrigin(Vector2f(0, font_size.f32()))
      .> setPosition(Vector2f(5, h-10))
      .> setColor(Color(0,0,255))
      .> setStyle(TextItalic)
      .> addStyle(TextUnderlined)

    window.setActive(false)
    
    timers(Timer(NotifyBehavior(recover this~draw() end), 0, 17_000_000))
    timers(Timer(NotifyBehavior(recover this~handle_evts() end), 0, 100_000_000))

  fun ref update_circle(t_now: U64) =>
    window.drawShape(circle)
    //if (t_now - t_last_circle_frame) > 3 then
      circle.rotate(wobble_rate)
      t_last_circle_frame = t_now
    //end

  fun ref update_vertex_array() =>
    window.drawVertexArray(vtx_arr, vtx_render_states)

  fun ref update_fps_text(t_now: U64) =>
    frames = frames + 1
    if (t_now - t_last_fps_frame) > 1000 then
      fps_text.setString("FPS: " + frames.string())
      frames = 0
      t_last_fps_frame = t_now
    end
    window.drawText(fps_text)

  be handle_evts(timer: Timer tag, count: U64) =>
    //window.setActive(true)
    if event.poll() then
      match event.translate()
      | let kevt : KeyEvent =>
        if kevt.code == KeyCode.sfKeyEscape() then
            running = false
        end
      | let wevt : WindowEvent =>
        None
      | QuitEvent => running = false
      end
    end
    window.setActive(false)

  be draw(timer: Timer tag, count: U64) =>
    //window.setActive(true)
    let t_now = Time.millis()
    window.clear(if count > 10 then color_red else color_gray end)
    update_circle(t_now) // draws a wobbly circle
    update_vertex_array()  // draws crossed lines
    update_fps_text(t_now)
    window.display()
    window.setActive(false)
