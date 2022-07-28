
// FFI declarations for CSFML functions
//
// None, because CSFML does not provide any functions for working with RenderStates.


// CSFML FFI Struct
//
// Because CSFML DOES NOT provide functions for creation or manipulation of
// this structure, we define it here in Pony. The only constraint on this 
// private struct is that it needs to match the memory layout of the 
// corresponding sfReenderStates in CSFML. Its methods can be *anything* useful
// to the private implementation of pony-sfml.
//
struct _RenderStates
    embed blendMode: BlendMode
    embed transform: _Transform
    var texture: _TextureRaw
    var shader: _ShaderRaw

    new create(bm: BlendMode, tf: _Transform, tex: _TextureRaw, sh: _ShaderRaw) =>
        blendMode = BlendMode.copy(bm) // Pony embed fields must be assigned using a ctor
        transform = _Transform.copy(tf) // Pony embed fields must be assigned using a ctor
        texture = tex
        shader = sh

type _RenderStatesRaw is NullablePointer[_RenderStates]

primitive _OptionalRenderStates
    fun toRaw(opt_rs: Optional[RenderStates]): _RenderStatesRaw =>
        match opt_rs
            | None => _RenderStatesRaw.none() 
            | let rs: RenderStates => rs._getRaw() 
        end


// Pony Proxy Class
//
// The goal for this class to be a Pony proxy for the corresponding SFML 
// C++ class. As far as is possible, given the differences between Pony
// and C++, this class should be identical to the corresponding C++ class.
// This will make it easy for users of pony-sfml to understand existing
// SFML docs and examples.
//
// This class must not publicly expose any FFI types.
//
class RenderStates
    let _raw: _RenderStatesRaw ref
    let _struct: _RenderStates

    new default() =>
        _struct = _RenderStates(BlendMode.blendAlpha(), _Transform.identity(), _TextureRaw.none(), _ShaderRaw.none())
        _raw = _RenderStatesRaw(_struct)

    new fromBlendMode(bm: BlendMode) =>
        _struct = _RenderStates(bm, _Transform.identity(), _TextureRaw.none(), _ShaderRaw.none())
        _raw = _RenderStatesRaw(_struct)

    new fromTransform(tf: Transform) =>
        _struct = _RenderStates(BlendMode.blendAlpha(), tf._getStruct(), _TextureRaw.none(), _ShaderRaw.none())
        _raw = _RenderStatesRaw(_struct)

    new fromTexture(tex: Texture) =>
        _struct = _RenderStates(BlendMode.blendAlpha(), _Transform.identity(), tex._getRaw(), _ShaderRaw.none())
        _raw = _RenderStatesRaw(_struct)

    new fromShader(sh: Shader) =>
        _struct = _RenderStates(BlendMode.blendAlpha(), _Transform.identity(), _TextureRaw.none(), sh._getRaw())
        _raw = _RenderStatesRaw(_struct)

    // TODO
    // fun setBlendMode(bm: BlendMode) =>
    //     _struct.blendMode.setFrom(bm._getStruct())

    fun ref setTransform(tf: Transform) =>
        _struct.transform.setFrom(tf._getStruct())

    fun ref setTexture(tex: Texture) =>
        _struct.texture = tex._getRaw()

    fun ref setShader(sh: Shader) =>
        _struct.shader = sh._getRaw()

    fun ref _getRaw(): _RenderStatesRaw =>
        _raw
