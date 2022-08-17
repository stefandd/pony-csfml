
// Based on https://stackoverflow.com/questions/8452301

use "../../sfml"

actor Main
    
  fun @runtime_override_defaults(rto: RuntimeOptions) =>
    rto.ponymaxthreads = 1

  fun tag create_rectangle(): RectangleShape? =>
    RectangleShape.create()?
      .> setFillColor(Color(250, 30, 30))
      .> setSize(Vector2f(200, 200))
      .> setPosition(Vector2f(100, 100))

  fun tag create_circle(x: F32, y: F32): CircleShape? =>
    CircleShape.create()?
      .> setRadius(50)
      .> setOrigin(Vector2f(50, 50))
      .> setPosition(Vector2f(x, y))
      .> setFillColor(Color(30, 30, 250))

  fun tag create_window(): RenderWindow? =>
    let vmode = VideoMode(400, 400, 32)
    let title = "BlendMode Sample"
    RenderWindow.create(vmode, title)?

  new create(env: Env) =>
    try
      run(
        create_window()?,
        create_rectangle()?,
        create_circle(100, 100)?,
        create_circle(300, 100)?,
        create_circle(100, 300)?,
        create_circle(300, 300)? )
    else
      env.out.print("Couldn't initialize the graphics.")
    end

  fun ref run(
    window: RenderWindow,
    square: RectangleShape,
    circle1: CircleShape,
    circle2: CircleShape,
    circle3: CircleShape,
    circle4: CircleShape )
  =>
    var running: Bool = true
    let event = window.getEventStruct()
    while running do

      while event.poll() do
        match event.translate()
        | let kevt : KeyEvent =>
          if kevt.code == KeyCode.sfKeyEscape() then
              running = false
          end
        | QuitEvent => running = false
        end
      end

      window.clear()
      window.drawShape(square)
      window.drawShape(circle1, RenderStates.fromBlendMode(BlendMode.alpha()))
      window.drawShape(circle2, RenderStates.fromBlendMode(BlendMode.add()))
      window.drawShape(circle3, RenderStates.fromBlendMode(BlendMode.multiply()))
      window.drawShape(circle4, RenderStates.fromBlendMode(BlendMode.none()))
      window.display()

      running = running and window.isOpen()
    end