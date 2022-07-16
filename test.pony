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
    var window : SFRenderWindow
    var event : SFEventStruct
    var texture : SFTexture
    var sprite : SFSprite
    let vtx_arr : SFVertexArray
    let circle : SFShape
    let fps_font : SFFont
    let fps_text : SFText
    let width : USize = 320
    let height : USize = 240
    var pixeldata : Array[U32] = Array[U32].init(0, width * height)
    let rand : Random = Rand
    var frames : U32 = 0
    var t_last_fps_frame : U64
    var t_last_circle_frame: U64
    var running: Bool

    fun @runtime_override_defaults(rto: RuntimeOptions) =>
      rto.ponymaxthreads = 1

    new create(env : Env) =>
      _env = env
      window = SFRenderWindow(SFVideoMode(width.u32(), height.u32(), 32), "SFML Demo", SFWindowStyle.sfDefaultStyle())
      let s : SFContextSettings = window.getSettings()
      event = window.getEventStruct()
      texture = SFTexture.createFromImage(SFImage(width.u32(), height.u32()))
      sprite = SFSprite

      let w = width.f32()
      let h = height.f32()
      let half_w = w / 2
      let half_h = h / 2

      let thickness: F32 = 1
      let wobble: F32 = 10
      let r = half_w.min(half_h) - thickness - wobble
      circle = SFCircleShape
        .> setRadius(r)
        .> setFillColor(SFColor(127,200,127))
        .> setOutlineColor(SFColor.black())
        .> setOutlineThickness(thickness)
        .> setPosition(SFVector2f(half_w, half_h))
        .> setOrigin(SFVector2f(r, r-wobble))

      let line_color = SFColor.fromInteger(0x00ff00ff)
      let center_vtx = SFVertex(SFVector2f(half_w, half_h), line_color, SFVector2f(0,0))
      let vertices = [
        center_vtx ; SFVertex(SFVector2f(0, 0), line_color)
        center_vtx ; SFVertex(SFVector2f(0, h), line_color)
        center_vtx ; SFVertex(SFVector2f(w, 0), line_color)
        center_vtx ; SFVertex(SFVector2f(w, h), line_color)
      ]
      vtx_arr = SFVertexArray
      vtx_arr.setPrimitiveType(SFPrimitiveType.sfLines())
      for v in vertices.values() do vtx_arr.append(v) end

      let font_size: U32 = 24
      fps_font = SFFont.create("Square.ttf") // https://www.dafont.com/squarefont.font
      fps_text = SFText.create()
        .> setFont(fps_font)
        .> setCharacterSize(font_size)
        .> setOrigin(SFVector2f(0, font_size.f32()))
        .> setPosition(SFVector2f(5, h-5))
        .> setColor(SFColor(0,0,255))

      t_last_fps_frame = Time.millis()
      t_last_circle_frame = Time.millis()
      running = true
      run()

    fun ref update_pixels() =>
      try
        for i in Range[USize](0, width * height) do
          pixeldata.update(i, 0xFF000000 or (rand.int(16777216).u32()))?
        end
      end
      texture.updateFromPixels(pixeldata.cpointer(), width.u32(), height.u32(), 0, 0)
      sprite.setTexture(texture) // map the texture to a sprite
      window.drawSprite(sprite) // draw the sprite
    

    fun ref update_circle(t_now: U64) =>
      window.drawShape(circle)
      if (t_now - t_last_circle_frame) > 50 then
        circle.rotate(18)
        t_last_circle_frame = t_now
      end

    fun ref update_vertex_array() =>
      window.drawVertexArray(vtx_arr)

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
        | let kevt : SFKeyEvent =>
          if kevt.code == SFKeyCode.sfKeyEscape() then
              running = false
          end
        | let wevt : SFWindowEvent =>
          if wevt.resized then
              _env.out.print(wevt.newsizex.string() + ", " + wevt.newsizey.string())
          end
        | SFQuitEvent => running = false
        end
      end

    be run() =>
      if running then // and window.hasFocus() do
        let t_now = Time.millis()

        poll_events()

        // Redraw
        window.clear(SFColor(127, 127, 127, 127))
        update_pixels() // draws random pixels
        update_circle(t_now) // draws a wobbly circle
        update_vertex_array()  // draws crossed lines
        update_fps_text(t_now) 
        window.display()

        // FPS info

        running = running and window.isOpen()
        run()
      else
        sprite.destroy()
        texture.destroy()
        vtx_arr.destroy()
        window.destroy()
        fps_font.destroy()
        fps_text.destroy()
      end
