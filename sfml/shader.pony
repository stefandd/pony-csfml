use @sfShader_createFromMemory[NullablePointer[_Shader]](vertexShader: Pointer[U8 val] tag, geometryShader: Pointer[U8 val] tag, fragmentShader: Pointer[U8 val] tag)
use @sfShader_setTextureParameter[None](shader: _Shader box, name: Pointer[U8 val] tag, texture: _Texture box)
use @sfShader_setFloatUniform[None](shader: _Shader box, name: Pointer[U8 val] tag, x: F32)
use @sfShader_destroy[None](shader: _Shader box)


struct _Shader

class Shader
    var _csfml: _Shader ref

    new createFromMemory(vertexShader: String val, geometryShader: String val, fragmentShader: String val)? =>
        // create NULL pointers if the String argument is "" and cstrings otherwise
        let nullptr = Pointer[U8 val].create()
        let vsarg = if vertexShader.size() == 0 then nullptr else vertexShader.cstring() end
        let gsarg = if geometryShader.size() == 0 then nullptr else geometryShader.cstring() end
        let fsarg = if fragmentShader.size() == 0 then nullptr else fragmentShader.cstring() end
        _csfml = @sfShader_createFromMemory(vsarg, gsarg, fsarg)()?

    new _fromCsfml(cptr: _Shader) => 
        _csfml = cptr

    fun ref setTextureParameter(name: String val, texture: Texture) =>
        @sfShader_setTextureParameter(_csfml, name.cstring(), texture._getCsfml())

    fun ref setFloatUniform(name: String val, floatval: F32) =>
        @sfShader_setFloatUniform(_csfml, name.cstring(), floatval)

    fun ref _getCsfml(): _Shader =>
        _csfml

    fun \deprecated\ ref destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        @sfShader_destroy(_csfml)