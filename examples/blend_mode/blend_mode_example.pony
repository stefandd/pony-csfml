
// Inspired by https://stackoverflow.com/questions/8452301

use "../../sfml"

actor Main
  let square: Shape
  let circle1: Shape
  let circle2: Shape
  let circle3: Shape
  let circle4: Shape
  let event: EventStruct
  let window: RenderWindow
  var running: Bool = true

  fun @runtime_override_defaults(rto: RuntimeOptions) =>
    rto.ponymaxthreads = 1

  fun tag make_circle(x: F32, y: F32): CircleShape =>
    CircleShape 
      .> setRadius(50) 
      .> setOrigin(Vector2f(50, 50))
      .> setPosition(Vector2f(x, y)) 
      .> setFillColor(Color(30, 30, 250))

  new create(env: Env) =>

    window = RenderWindow(VideoMode(400, 400, 32), "BlendMode Sample", WindowStyle.sfDefaultStyle())

    square = RectangleShape
      .> setFillColor(Color(250, 30, 30))
      .> setSize(Vector2f(200, 200))
      .> setPosition(Vector2f(100, 100))

    circle1 = make_circle(100, 100)
    circle2 = make_circle(300, 100)
    circle3 = make_circle(100, 300)
    circle4 = make_circle(300, 300)

    event = window.getEventStruct()
    run()
    
  be run() =>
    if running then
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
      run()
    end