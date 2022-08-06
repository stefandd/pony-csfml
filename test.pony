use "sfml"
use "time"
use "buffered"
use "collections"
use "random"
use "debug"
use "assert"

use @fprintf[I32](stream: Pointer[U8] tag, fmt: Pointer[U8] tag, ...)
use @pony_os_stdout[Pointer[U8]]()
use @pony_os_stderr[Pointer[U8]]()

actor Main
    let _env : Env
    var window : RenderWindow
    var event : EventStruct
    var texture : Texture
    var sprite : Sprite
    let vtx_arr : VertexArray
    let circle : Shape
    let fps_font : Font
    let fps_text : Text
    let width : USize = 320
    let height : USize = 240
    var pixeldata : Array[U32] = Array[U32].init(0, width * height)
    let rand : Random = Rand
    var frames : U32 = 0
    var t_last_fps_frame: U64 = 0
    var t_last_circle_frame: U64 = 0
    var running: Bool = true
    let vtx_render_states: RenderStates = RenderStates.fromBlendMode(BlendMode.multiply())

    fun @runtime_override_defaults(rto: RuntimeOptions) =>
      rto.ponymaxthreads = 1

    new create(env : Env) =>
      _env = env
      window = RenderWindow(VideoMode(width.u32(), height.u32(), 32), "SFML Demo", WindowStyle.sfDefaultStyle())
      let s : ContextSettings = window.getSettings()
      event = window.getEventStruct()
      
      texture = Texture.createFromImage(Image(width.u32(), height.u32()))
      sprite = Sprite
      sprite.setTexture(texture) // map the texture to a sprite

      let w = width.f32()
      let h = height.f32()
      let half_w = w / 2
      let half_h = h / 2

      let thickness: F32 = 1
      let wobble: F32 = 10
      let r = half_w.min(half_h) - thickness - wobble
      circle = CircleShape.create()
        .> setRadius(r)
        .> setFillColor(Color(127,200,127))
        .> setOutlineColor(Color.black())
        .> setOutlineThickness(thickness)
        .> setPosition(Vector2f(half_w, half_h))
        .> setOrigin(Vector2f(r, r-wobble))

      let vtx = { box (x: F32, y: F32): Vertex => Vertex(Vector2f(x, y), Color.red()) }
      let vertices = [vtx(0, 0) ; vtx(w, h) ; vtx(0, h) ; vtx(w, 0)]
      vtx_arr = VertexArray.create() .> setPrimitiveType(Lines)
      for v in vertices.values() do vtx_arr.append(v) end

      let font_size: U32 = 24
      fps_font = Font.create("Square.ttf") // https://www.dafont.com/squarefont.font
      fps_text = Text.create()
        .> setFont(fps_font)
        .> setCharacterSize(font_size)
        .> setOrigin(Vector2f(0, font_size.f32()))
        .> setPosition(Vector2f(5, h-10))
        .> setColor(Color(0,0,255))
        .> setStyle(TextItalic)
        .> addStyle(TextUnderlined)

      run()

    fun ref update_pixels() =>
      try
        for i in Range[USize](0, width * height) do
          pixeldata.update(i, 0xFF000000 or (rand.int(16777216).u32()))?
        end
      end
      texture.updateFromPixels(pixeldata.cpointer(), width.u32(), height.u32(), 0, 0)
      window.drawSprite(sprite) // draw the sprite
    

    fun ref update_circle(t_now: U64) =>
      window.drawShape(circle)
      if (t_now - t_last_circle_frame) > 50 then
        circle.rotate(18)
        t_last_circle_frame = t_now
      end

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

    fun ref poll_events() =>
      if event.poll() then
        match event.translate()
        | let kevt : KeyEvent =>
          if kevt.code == KeyCode.sfKeyEscape() then
              running = false
          end
        | let wevt : WindowEvent =>
          if wevt.resized then
              _env.out.print(wevt.newsizex.string() + ", " + wevt.newsizey.string())
          end
        | QuitEvent => running = false
        end
      end

    be run() =>
      if running then // and window.hasFocus() do
        let t_now = Time.millis()

        poll_events()

        // Redraw
        window.clear(Color(127, 127, 127, 127))
        update_pixels() // draws random pixels
        update_circle(t_now) // draws a wobbly circle
        update_vertex_array()  // draws crossed lines
        update_fps_text(t_now) 
        window.display()

        // FPS info

        running = running and window.isOpen()
        run()
      end
