use @sfShader_createFromMemory[_ShaderRaw](vertexShader: Pointer[U8 val] tag, geometryShader: Pointer[U8 val] tag, fragmentShader: Pointer[U8 val] tag)
use @sfShader_setTextureParameter[None](shader: _ShaderRaw box, name: Pointer[U8 val] tag, texture: _TextureRaw box)
use @sfShader_setFloatUniform[None](shader: _ShaderRaw box, name: Pointer[U8 val] tag, x: F32)
use @sfShader_destroy[None](shader: _ShaderRaw box)


struct _Shader
type _ShaderRaw is NullablePointer[_Shader]


class Shader
    var _raw: _ShaderRaw ref

    new none() => 
        _raw = _ShaderRaw.none()
        
    new createFromMemory(vertexShader: String val, geometryShader: String val, fragmentShader: String val) =>
        // create NULL pointers if the String argument is "" and cstrings otherwise
        let vsarg = if vertexShader.size() == 0 then Pointer[U8 val].create() else vertexShader.cstring() end
        let gsarg = if geometryShader.size() == 0 then Pointer[U8 val].create() else geometryShader.cstring() end
        let fsarg = if fragmentShader.size() == 0 then Pointer[U8 val].create() else fragmentShader.cstring() end
        _raw = @sfShader_createFromMemory(vsarg, gsarg, fsarg)

    fun ref setTextureParameter(name: String val, texture: Texture) =>
        @sfShader_setTextureParameter(_raw, name.cstring(), texture._getRaw())

    fun ref setFloatUniform(name: String val, floatval: F32) =>
        @sfShader_setFloatUniform(_raw, name.cstring(), floatval)

    fun ref _getRaw(): _ShaderRaw =>
        _raw

    fun \deprecated\ ref destroy() => 
        """ Because Pony has garbage collection, you don't need to call destroy() """
        None

    fun _final() =>
        if not _raw.is_none() then @sfShader_destroy(_raw) end