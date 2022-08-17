use "sfml"
use "time"
use "buffered"
use "collections"
use "random"
use "debug"

use @fprintf[I32](stream: Pointer[U8] tag, fmt: Pointer[U8] tag, ...)
use @pony_os_stdout[Pointer[U8]]()
use @pony_os_stderr[Pointer[U8]]()

actor Main
  // CONSTANTS
  let env: Env
  let width: USize = 320
  let height: USize = 240
  let rand: Rand = Rand
  let pixeldata: Array[U32] = Array[U32].init(0, width * height)
  let vtx_rstates: RenderStates = RenderStates.fromBlendMode(BlendMode.multiply())
  let stdout: Pointer[U8] = @pony_os_stdout()
  // APP STATE
  var fps_count: U32 = 0
  var t_last_fps_update: U64 = 0
  var t_last_circle_update: U64 = 0
  var running: Bool = true

  fun @runtime_override_defaults(rto: RuntimeOptions) =>
    rto.ponymaxthreads = 1

  new create(env': Env) =>
    env = env'
    let vmode = VideoMode(width.u32(), height.u32(), 32)
    try
      let img = Image(width.u32(), height.u32())?
      run(
        RenderWindow(vmode, "SFML Demo")?,
        Texture.createFromImage(consume img)?,
        Sprite.create()?,
        CircleShape.create()?,
        VertexArray.create()?,
        Font.create("Square.ttf")?, // https://www.dafont.com/squarefont.font
        Text.create()?)
    else
      env.out.print("Couldn't initialize graphics")
    end

  // THE MAIN LOOP

  fun ref run(
    window: RenderWindow,
    texture: Texture,
    sprite: Sprite,
    circle: CircleShape,
    vtx_arr: VertexArray,
    fps_font: Font,
    fps_text: Text )
  =>
    config_sprite(sprite, texture)
    config_circle(circle)
    config_vtx_array(vtx_arr)
    config_fps_text(fps_text, fps_font)
    t_last_fps_update = Time.millis()

    while running do // and window.hasFocus() do

      // Handle events and update state
      poll_events(window.getEventStruct())
      randomize_pixels(texture)
      let t_now = Time.millis()
      update_circle_state(t_now, circle)
      update_fps_state(t_now, fps_text)
      running = running and window.isOpen()

      // Redraw the scene
      window.clear(Color(127, 127, 127, 127))
      window.drawSprite(sprite)                    // draws random pixels
      window.drawShape(circle)                     // draws a wobbly circle
      window.drawVertexArray(vtx_arr, vtx_rstates) // draws crossed lines
      window.drawText(fps_text)                    // draws fps text
      window.display()

    end

  // CONFIGURE GRAPHIC ITEMS

  fun config_sprite(sprite: Sprite, texture: Texture) =>
    sprite.setTexture(texture) // map the texture to a sprite

  fun config_circle(circle: CircleShape) =>
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

  fun config_vtx_array(vtx_arr: VertexArray) =>
    let w = width.f32()
    let h = height.f32()
    let vtx = { box (x: F32, y: F32): Vertex => Vertex(Vector2f(x, y), Color.red()) }
    let vertices = [vtx(0, 0) ; vtx(w, h) ; vtx(0, h) ; vtx(w, 0)]
    for v in vertices.values() do vtx_arr.append(v) end
    vtx_arr.setPrimitiveType(Lines)

  fun config_fps_text(fps_text: Text, fps_font: Font) =>
    let font_size: U32 = 24
    fps_text
      .> setFont(fps_font)
      .> setCharacterSize(font_size)
      .> setOrigin(Vector2f(0, font_size.f32()))
      .> setPosition(Vector2f(5, height.f32() - 10))
      .> setColor(Color(0,0,255))
      .> setStyle(TextItalic)
      .> addStyle(TextUnderlined)

  // UPDATE THE STATE

  fun ref randomize_pixels(texture: Texture) =>
    for i in Range[USize](0, width * height) do
      let pixelValue = 0xFF000000 or rand.int(16777216).u32()
      try pixeldata.update(i, pixelValue)? end
    end
    texture.updateFromPixels(pixeldata.cpointer(), width.u32(), height.u32(), 0, 0)

  fun ref update_circle_state(t_now: U64, circle: CircleShape) =>
    if (t_now - t_last_circle_update) > 50 then
      circle.rotate(18)
      t_last_circle_update = t_now
    end

  fun ref update_fps_state(t_now: U64, fps_text: Text) =>
    fps_count = fps_count + 1
    if (t_now - t_last_fps_update) > 1000 then
      fps_text.setString("FPS: " + fps_count.string())
      fps_count = 0
      t_last_fps_update = t_now
    end

  // HANDLE EVENTS

  fun ref poll_events(event: EventStruct) =>
    if event.poll() then
      match event.translate()
      | let kevt : KeyEvent =>
        if kevt.code == KeyCode.sfKeyEscape() then
            running = false
        end
      | let wevt : WindowEvent =>
        if wevt.resized then
            @fprintf(stdout, "%lu, %lu\n".cpointer(), wevt.newsizex, wevt.newsizey)
        end
      | QuitEvent => running = false
      end
    end
