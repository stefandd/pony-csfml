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
    var tx: NullablePointer[_Texture]
    var sh: NullablePointer[_Shader]

    new create(
        bm': _BlendMode box, 
        tf': _Transform, 
        tx': NullablePointer[_Texture], 
        sh': NullablePointer[_Shader] ) 
    =>
        bm = _BlendMode.copy(bm') // Pony embed fields must be assigned using a ctor
        tf = _Transform.copy(tf') // Pony embed fields must be assigned using a ctor
        tx = tx'
        sh = sh'

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class RenderStates
    let _csfml: _RenderStates

    new default() =>
        _csfml = _RenderStates(
            _BlendMode.alpha(),
            _Transform.identity(), 
            NullablePointer[_Texture].none(), 
            NullablePointer[_Shader].none() )

    new from(x: (BlendMode | Transform | Texture | Shader)) =>
    
        _csfml = match x

        | let bm: BlendMode => 
            _RenderStates(
                bm._getCsfml(),
                _Transform.identity(),
                NullablePointer[_Texture].none(),
                NullablePointer[_Shader].none() )

        | let tf: Transform =>
            _RenderStates(
                _BlendMode.alpha(),
                tf._getCsfml(),
                NullablePointer[_Texture].none(),
                NullablePointer[_Shader].none() )

        | let tx: Texture =>
            _RenderStates(
                _BlendMode.alpha(),
                _Transform.identity(),
                NullablePointer[_Texture](tx._getCsfml()),
                NullablePointer[_Shader].none() )

        | let sh: Shader =>
            _RenderStates(
                _BlendMode.alpha(),
                _Transform.identity(),
                NullablePointer[_Texture].none(),
                NullablePointer[_Shader](sh._getCsfml()) )

        end

    fun ref getBlendMode(): 
        BlendMode box => BlendMode._fromCsfml(_csfml.bm)

    fun ref getTransform(): Transform box => 
        Transform._fromCsfml(_csfml.tf)

    fun ref getTexture(): (Texture box | None) =>
        try Texture._fromCsfml(_csfml.tx()?) else None end

    fun ref getShader(): (Shader box | None) => 
        try Shader._fromCsfml(_csfml.sh()?) else None end

    fun ref setBlendMode(x: BlendMode) => 
        _csfml.bm.setFrom(x._getCsfml())

    fun ref setTransform(x: Transform) => 
        _csfml.tf.setFrom(x._getCsfml())

    fun ref setTexture(x: Optional[Texture]) => 
        _csfml.tx = 
            match x
            | None => NullablePointer[_Texture].none()
            | let t: Texture => NullablePointer[_Texture](t._getCsfml())
            end

    fun ref setShader(x: Optional[Shader]) => 
        _csfml.sh = 
            match x
            | None => NullablePointer[_Shader].none()
            | let s: Shader => NullablePointer[_Shader](s._getCsfml())
            end

    fun ref _getCsfml(): _RenderStates => _csfml
