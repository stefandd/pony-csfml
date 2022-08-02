struct ContextSettings
    let depthBits: U32         ///< Bits of the depth buffer
    let stencilBits: U32       ///< Bits of the stencil buffer
    let antialiasingLevel: U32 ///< Level of antialiasing
    let majorVersion: U32      ///< Major number of the context version to create
    let minorVersion: U32      ///< Minor number of the context version to create
    let attributeFlags: U32    ///< The attribute flags to create the context with
    let sRgbCapable: I32      ///< Whether the context framebuffer is sRGB capable

    // TODO: Default args per https://www.sfml-dev.org/documentation/2.5.1/structsf_1_1ContextSettings.php
    new create(depth: U32, sbits: U32, aalev: U32, majver: U32, minver: U32, attr: U32, isRGB: I32) =>
        depthBits = depth
        stencilBits = sbits
        antialiasingLevel = aalev
        majorVersion = majver
        minorVersion = minver
        attributeFlags = attr
        sRgbCapable = isRGB

type ContextSettingsRaw is NullablePointer[ContextSettings]

