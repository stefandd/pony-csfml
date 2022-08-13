// 
// The SFML object as presented by CSFML
// 
// Because CSFML DOES NOT provide functions to create this structure, we will 
// be allocating them here, in pony-sfml. The only constraint on this private
// struct is that it needs to match the memory layout of the corresponding 
// sfRenderStates in CSFML. Its methods can be *anything* useful to the private
// implementation of pony-sfml.
//
struct _RenderStates
    embed bm: _BlendMode
    embed tf: _Transform
    var tx: _TextureRaw
    var sh: _ShaderRaw

    new create(bm': _BlendMode box, tf': _Transform, tx': _TextureRaw, sh': _ShaderRaw) =>
        bm = _BlendMode.copy(bm') // Pony embed fields must be assigned using a ctor
        tf = _Transform.copy(tf') // Pony embed fields must be assigned using a ctor
        tx = tx'
        sh = sh'

type _RenderStatesRaw is NullablePointer[_RenderStates]

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class RenderStates
    let _struct: _RenderStates
    let _raw: _RenderStatesRaw ref

    var _bm: BlendMode
    var _tf: Transform
    var _tx: Texture
    var _sh: Shader

    new default() =>
        _bm = BlendMode.alpha()
        _tf = Transform.identity()
        _tx = Texture.none()
        _sh = Shader.none()
        _struct = _RenderStates(_bm._getCsfml(), _tf._getStruct(), _tx._getRaw(), _sh._getRaw())
        _raw = _RenderStatesRaw(_struct)

    new fromBlendMode(blendMode: BlendMode) =>
        _bm = blendMode
        _tf = Transform.identity()
        _tx = Texture.none()
        _sh = Shader.none()
        _struct = _RenderStates(_bm._getCsfml(), _tf._getStruct(), _tx._getRaw(), _sh._getRaw())
        _raw = _RenderStatesRaw(_struct)

    new fromTransform(transform: Transform) =>
        _bm = BlendMode.alpha()
        _tf = transform
        _tx = Texture.none()
        _sh = Shader.none()
        _struct = _RenderStates(_bm._getCsfml(), _tf._getStruct(), _tx._getRaw(), _sh._getRaw())
        _raw = _RenderStatesRaw(_struct)

    new fromTexture(texture: Texture) =>
        _bm = BlendMode.alpha()
        _tf = Transform.identity()
        _tx = texture
        _sh = Shader.none()
        _struct = _RenderStates(_bm._getCsfml(), _tf._getStruct(), _tx._getRaw(), _sh._getRaw())
        _raw = _RenderStatesRaw(_struct)

    new fromShader(shader: Shader) =>
        _bm = BlendMode.alpha()
        _tf = Transform.identity()
        _tx = Texture.none()
        _sh = shader
        _struct = _RenderStates(_bm._getCsfml(), _tf._getStruct(), _tx._getRaw(), _sh._getRaw())
        _raw = _RenderStatesRaw(_struct)

    fun box getBlendMode(): BlendMode box => _bm
    fun box getTransform(): Transform box => _tf
    fun box getTexture(): Texture box     => _tx
    fun box getShader(): Shader box       => _sh

    fun ref setBlendMode(x: BlendMode) => _bm = x ; _struct.bm.setFrom(x._getCsfml())
    fun ref setTransform(x: Transform) => _tf = x ; _struct.tf.setFrom(x._getStruct())
    fun ref setTexture(x: Texture)     => _tx = x ; _struct.tx = x._getRaw()
    fun ref setShader(x: Shader)       => _sh = x ; _struct.sh = x._getRaw()

    fun ref _getRaw(): _RenderStatesRaw =>
        _raw

// RenderStates are often optional parameters in SFML draw functions.
// This helper converts Optional[RenderState] to _RenderStateRaw.
//
// Sadly, this can't be genericized to work with ANY proxy class because that
// would require structs to be type arguments in a "trait Proxy[SomeStruct]", 
// but Pony doesn't allow structs to be type args.
//
primitive _ToRenderStatesRaw
    fun apply(opt_rs: Optional[RenderStates]): _RenderStatesRaw =>
        match opt_rs
            | None => _RenderStatesRaw.none() 
            | let rs: RenderStates => rs._getRaw() 
        end

