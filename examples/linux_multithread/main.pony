use "../../sfml"
use "collections"
use "lib:X11"
use @XInitThreads[I32]()

// Credit to: https://www.dafont.com/squarefont.font
// Design pattern: https://patterns.ponylang.io/creation/supply-chain.html

actor Main

  new create(env : Env) =>
    let width: USize = 320
    let height: USize = 240

    if @XInitThreads() == 0 then
      env.out.print("XInitThreads failed.")
    else
      for n in Range(0,9) do
        let vmode = recover val VideoMode(width.u32(), height.u32(), 32) end
        let wstyle = WindowStyle.sfTitlebar()
        let title = "SFML Demo"

        try
          // The rate of the circle's off-center rotation, in deg/frame.
          let wobl = 3.0 + (n.f32()/3.0)

          DemoActor(
            env, width, height, wobl,
            recover RenderWindow.create(vmode, title, wstyle)? end,
            recover VertexArray.create()?                      end,
            recover CircleShape.create()?                      end,
            recover Font.create("../../Square.ttf")?           end,
            recover Text.create()?                             end )
        else
          env.out.print("Couldn't initialize GUI.")
        end
      end
    end