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
    let width : USize = 320
    let height : USize = 240
    var pixeldata : Array[U32] = Array[U32].init(0, width * height)
    let rand : Random = Rand
    var frames : U32 = 0
    var t_lastframe : U64
    var running: Bool

    fun @runtime_override_defaults(rto: RuntimeOptions) =>
        rto.ponymaxthreads = 1

    new create(env : Env) =>
        _env = env
        window = SFRenderWindow(SFVideoMode(width.u32(), height.u32(), 32), "SFML Game", SFWindowStyle.sfDefaultStyle())
        let s : SFContextSettings = window.getSettings()
        event = window.getEventStruct()
        texture = SFTexture.createFromImage(SFImage(width.u32(), height.u32()))
        sprite = SFSprite

        let w = width.f32()
        let h = height.f32()
        let half_w = w / 2
        let half_h = h / 2

        let thickness: F32 = 3
        let r = half_w.min(half_h) - thickness
        let thick_r = r + thickness
        let pos_x = half_w - thick_r
        let pos_y = thickness
        circle = SFCircleShape
        circle.setPosition(SFVector2f(pos_x, pos_y))
        circle.setRadius(r)
        circle.setFillColor(SFColor(127,200,127))
        circle.setOutlineColor(SFColor(0,0,0))
        circle.setOutlineThickness(thickness)

        let line_color = SFColor.from_u32(0xff0000ff)
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

        t_lastframe = Time.millis()
        running = true
        run()

    fun ref update_pixels() =>
        try
            for i in Range[USize](0, width * height) do
                pixeldata.update(i, 0xFF000000 or (rand.int(16777216).u32()))?
            end
        end
        texture.updateFromPixels(pixeldata.cpointer(), width.u32(), height.u32(), 0, 0)

    be run() =>
        if running then // and window.hasFocus() do
            let t_now = Time.millis()
            frames = frames + 1
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
            update_pixels() // write random pixels into the texture
            sprite.setTexture(texture) // map the texture to a sprite

            window.clear(SFColor(127, 127, 127, 127))
            window.drawSprite(sprite) // draw the sprite
            window.drawShape(circle)
            window.drawVertexArray(vtx_arr)
            window.display()

            // FPS info
            if (t_now- t_lastframe) > 1000 then
                @fprintf(@pony_os_stdout(), "FPS: %s\n".cstring(), frames.string().cstring())
                frames = 0
                t_lastframe = t_now
            end
            running = running and window.isOpen()
            run()
        else
            sprite.destroy()
            texture.destroy()
            vtx_arr.destroy()
            window.destroy()
        end
