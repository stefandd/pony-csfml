//
// The SFML object as presented by CSFML
//
struct _ContextSettings
    let depthBits: U32         // Bits of the depth buffer
    let stencilBits: U32       // Bits of the stencil buffer
    let antialiasingLevel: U32 // Level of antialiasing
    let majorVersion: U32      // Major number of the context version to create
    let minorVersion: U32      // Minor number of the context version to create
    let attributeFlags: U32    // The attribute flags to create the context with
    let sRgbCapable: I32       // Whether the context framebuffer is sRGB capable

    new create(depth: U32, sbits: U32, aalev: U32, majver: U32, minver: U32, attr: U32, isRGB: I32) =>
        depthBits = depth
        stencilBits = sbits
        antialiasingLevel = aalev
        majorVersion = majver
        minorVersion = minver
        attributeFlags = attr
        sRgbCapable = isRGB

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class ContextSettings
    let _csfml: _ContextSettings

    // Default args per https://www.sfml-dev.org/documentation/2.5.1/structsf_1_1ContextSettings.php
    new create(
        depth: U32  = 0,
        sbits: U32  = 0,
        aalev: U32  = 0,
        majver: U32 = 1,
        minver: U32 = 1,
        attrs: Array[ContextSettingsAttribute] = [ContextSettingsDefault],
        isRGB: Bool = false)
    =>
        let isRGBint: I32 = if isRGB then 1 else 0 end
        var attrsNum: U32 = 0
        var n = attrs.size()
        try while n > 0 do n = n - 1 ; attrsNum = attrsNum or attrs(n)?() end end
        _csfml = _ContextSettings(depth, sbits, aalev, majver, minver, attrsNum, isRGBint)

    fun getDepthBits(): U32 => _csfml.depthBits
    fun getStencilBits(): U32 => _csfml.stencilBits
    fun getAntialiasingLevel(): U32 => _csfml.antialiasingLevel
    fun getMajorVersion(): U32 => _csfml.majorVersion
    fun getMinorVersion(): U32 => _csfml.minorVersion
    fun getAttributeFlags(): U32 => _csfml.attributeFlags
    fun getSRgbCapable(): Bool => if _csfml.sRgbCapable == 1 then true else false end

    fun box string(): String iso^ => 
        "\nDepth Bits: " + getDepthBits().string() +
        "\nStencil Bits: " + getStencilBits().string() +
        "\nAntialiasing Level: " + getAntialiasingLevel().string() +
        "\nMajor Version: " + getMajorVersion().string() +
        "\nMinor Version: " + getMinorVersion().string() +
        "\nAttribute Flags: " + getAttributeFlags().string() +
        "\nsRgb Capable: " + getSRgbCapable().string() + "\n"

    fun ref _getCsfml(): _ContextSettings => _csfml


primitive ContextSettingsDefault fun apply(): U32 => 0
primitive ContextSettingsCore    fun apply(): U32 => 1 << 0
primitive ContextSettingsDebug   fun apply(): U32 => 1 << 2 // not a typo

type ContextSettingsAttribute is
    ( ContextSettingsDefault
    | ContextSettingsCore
    | ContextSettingsDebug )
