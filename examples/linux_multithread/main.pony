use "../../sfml"
use "collections"
use "lib:X11"
use @XInitThreads[I32]()

// Credit to: https://www.dafont.com/squarefont.font
// Design pattern: https://patterns.ponylang.io/creation/supply-chain.html

actor Main
  let _env : Env
  let width : USize = 320
  let height : USize = 240

  new create(env : Env) =>
    _env = env

    @XInitThreads()

    for n in Range(0,9) do
      let vmode = recover val VideoMode(width.u32(), height.u32(), 32) end
      let wstyle = WindowStyle.sfTitlebar()
      let title = "SFML Demo"

      try
        let window:   RenderWindow iso = recover RenderWindow.create(vmode, title, wstyle)? end
        let vtx_arr:  VertexArray iso  = recover VertexArray.create()?                      end
        let circle:   CircleShape iso  = recover CircleShape.create()?                      end
        let fps_font: Font iso         = recover Font.create("../../Square.ttf")?           end
        let fps_text: Text iso         = recover Text.create()?                             end

        window.setActive(false)

        // The rate of the circle's off-center rotation, in deg/frame.
        let wobl = 3.0 + (n.f32()/3.0)

        DemoActor(
          env, width, height, wobl,
          consume window,
          consume vtx_arr,
          consume circle,
          consume fps_font,
          consume fps_text )
      else
        env.out.print("Couldn't initialize GUI.")
      end
    end

