struct _RenderStates 
    embed blendMode: BlendMode
    embed transform: Transform
    var texture: _TextureRaw box
    var shader: _ShaderRaw box

    new create(bm: BlendMode, tf: Transform, tex: _TextureRaw box, sh: _ShaderRaw box) =>
        blendMode = BlendMode.copy(bm) // Pony embed fields must be assigned using a ctor
        transform = Transform.copy(tf) // Pony embed fields must be assigned using a ctor
        texture = tex
        shader = sh

type _RenderStatesRaw is NullablePointer[_RenderStates]

primitive _RenderStatesUtils
    fun getRaw(maybe_render_states: (RenderStates | None)): _RenderStatesRaw =>
        match maybe_render_states
            | None => _RenderStatesRaw.none() 
            | let rs: RenderStates => rs._getRaw() 
        end

// Pony Abstraction
class RenderStates
    let _raw: _RenderStatesRaw ref
    let _struct: _RenderStates

    new default() =>
        _struct = _RenderStates(BlendMode.blendAlpha(), Transform, _TextureRaw.none(), _ShaderRaw.none())
        _raw = _RenderStatesRaw(_struct)

    new fromBlendMode(bm: BlendMode) =>
        _struct = _RenderStates(BlendMode.copy(bm), Transform, _TextureRaw.none(), _ShaderRaw.none())
        _raw = _RenderStatesRaw(_struct)

    new fromTransform(tf: Transform) =>
        _struct = _RenderStates(BlendMode.blendAlpha(), Transform.copy(tf), _TextureRaw.none(), _ShaderRaw.none())
        _raw = _RenderStatesRaw(_struct)

    new fromTexture(tex: Texture) =>
        _struct = _RenderStates(BlendMode.blendAlpha(), Transform, tex._getRaw(), _ShaderRaw.none())
        _raw = _RenderStatesRaw(_struct)

    new fromShader(sh: Shader) =>
        _struct = _RenderStates(BlendMode.blendAlpha(), Transform, _TextureRaw.none(), sh._getRaw())
        _raw = _RenderStatesRaw(_struct)

    fun setBlendMode(bm: BlendMode) =>
        _struct.blendMode.copy(bm)

    fun setTransform(tf: Transform) =>
        _struct.transform.copy(tf)

    fun ref setTexture(tex: Texture) =>
        _struct.texture = tex._getRaw()

    fun ref setShader(sh: Shader) =>
        _struct.shader = sh._getRaw()

    fun ref _getRaw(): _RenderStatesRaw =>
        _raw
