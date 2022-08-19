use "debug"
//
// The SFML object as presented by CSFML
//
struct _ContextSettings
    let dbits: U32
    let sbits: U32
    let aalvl: U32
    let major: U32
    let minor: U32
    let attrs: U32
    let sRgb: I32

    new create(dbits': U32, sbits': U32, aalvl': U32, major': U32, minor': U32, attrs': U32, sRgb': I32) =>
        dbits = dbits'
        sbits = sbits'
        aalvl = aalvl'
        major = major'
        minor = minor'
        attrs = attrs'
        sRgb = sRgb'

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class ContextSettings
    let _csfml: _ContextSettings

    // Default args per https://www.sfml-dev.org/documentation/2.5.1/structsf_1_1ContextSettings.php
    new create(
        depth: U32  = 0,
        stencil: U32  = 0,
        antialiasing: U32  = 0,
        major: U32 = 1,
        minor: U32 = 1,
        attributes: ContextAttributes = ContextAttributes.default(),
        sRgb: Bool = false) =>
        """
        | Param        | Description                                     |
        |:-------------|:------------------------------------------------|
        | depth        | Bits of the depth buffer                        |
        | stencil      | Bits of the stencil buffer                      |
        | antialiasing | Level of antialiasing                           |
        | major        | Major number of the context version to create   |
        | minor        | Minor number of the context version to create   |
        | attributes   | The attribute flags to create the context with  |
        | sRgb         | Whether the context framebuffer is sRGB capable |
        """
        _csfml = _ContextSettings(
          depth, stencil, antialiasing, 
          major, minor, 
          attributes._u32(), 
          if sRgb then I32(1) else I32(0) end)

    fun getDepthBits(): U32 => _csfml.dbits
    fun getStencilBits(): U32 => _csfml.sbits
    fun getAntialiasingLevel(): U32 => _csfml.aalvl
    fun getMajorVersion(): U32 => _csfml.major
    fun getMinorVersion(): U32 => _csfml.minor
    fun getAttributeFlags(): ContextAttributes => ContextAttributes._from_u32(_csfml.attrs)
    fun getSRgbCapable(): Bool => if _csfml.sRgb == 1 then true else false end

    fun box string(): String iso^ =>
        "\nDepth Bits: "         + _csfml.dbits.string()  +
        "\nStencil Bits: "       + _csfml.sbits.string()  +
        "\nAntialiasing Level: " + _csfml.aalvl.string()  +
        "\nMajor Version: "      + _csfml.major.string() +
        "\nMinor Version: "      + _csfml.minor.string() +
        "\nAttribute Flags: "    + _csfml.attrs.string()  +
        "\nsRgb Capable: "       + _csfml.sRgb.string()   + 
        "\n"

    fun ref _getCsfml(): _ContextSettings => _csfml


//
// Related "enumerations"
//

primitive _CoreAttrValue  fun apply(): U32 => 1 << 0
primitive _DebugAttrValue fun apply(): U32 => 1 << 2 // This is not a typo

class ContextAttributes
  """
  In SFML (C++), context flags are an enum and are combined by "or"ing.
  In Pony-SFML, we instead use this class and set flags by calling its methods.
  Method calls are chained to set multiple flags. For example:

  C++: `sf::ContextSettings::Core | sf::ContextSettings::Debug`

  becomes:

  Pony: `ContextAttributes.core().debug()`
  """
  var _val: U32 = 0
  var _default_was_called: Bool = false
  var _core_was_called:    Bool = false

  new create() => None

  fun ref _error() =>
    Debug("Error: You have attempted to combine incompatible context attrs.")

  fun ref default(): ContextAttributes =>
    "Non-debug, compatibility context (this and the core attribute are mutually exclusive)"
    if _core_was_called then 
      _error()
      Debug("Call to default() has been ignored.")
    else 
      _default_was_called = true 
    end
    this

  fun ref core(): ContextAttributes =>
    "Core attribute (this and the default attribute are mutually exclusive)"
    if _default_was_called then 
      _error() 
      Debug("Call to core() has been ignored.")
    else 
      _core_was_called = true 
      _val = _val or _CoreAttrValue()
    end
    this

  fun ref debug(): ContextAttributes =>
    "Debug attribute"
    _val = _val or _DebugAttrValue()
    this

  fun isDefault(): Bool => not isCore()
  fun isCore():    Bool => (_val and _CoreAttrValue()) > 0
  fun isDebug():   Bool => (_val and _DebugAttrValue()) > 0

  fun _u32(): U32 => _val

  new _from_u32(u32: U32) =>
    _val = u32