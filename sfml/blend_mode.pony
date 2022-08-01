// CSFML FFI Struct
//
// The only constraint on this private struct is that it needs to match the 
// memory layout of the corresponding CSFML concept. Its methods can be
// *anything* useful to the private implementation of pony-sfml.
//
struct _BlendMode

    // Field names don't matter in the private struct so shorter names will be used:
    var csf: I32  // Source blending factor for the color channels
    var cdf: I32  // Destination blending factor for the color channels
    var ceq: I32  // Blending equation for the color channels
    var asf: I32  // Source blending factor for the alpha channel
    var adf: I32  // Destination blending factor for the alpha channel
    var aeq: I32  // Blending equation for the alpha channel

    new create(
        csf': _BMFact, cdf': _BMFact, ceq': _BMEqtn, 
        asf': _BMFact, adf': _BMFact, aeq': _BMEqtn) 
    =>
        csf = csf'._i32() ; cdf = cdf'._i32() ; ceq = ceq'._i32()
        asf = asf'._i32() ; adf = adf'._i32() ; aeq = aeq'._i32()

    new copy(that: _BlendMode box) =>
        csf = that.csf ; cdf = that.cdf ; ceq = that.ceq
        asf = that.asf ; adf = that.adf ; aeq = that.aeq

    fun ref setFrom(that: _BlendMode) =>
        csf = that.csf ; cdf = that.cdf ; ceq = that.ceq
        asf = that.asf ; adf = that.adf ; aeq = that.aeq

type _BlendModeRaw is NullablePointer[_BlendMode]


// Pony Proxy Class
//
// The goal for this class is to be a Pony proxy for the corresponding SFML
// C++ class. As far as is possible, given the differences between Pony
// and C++, this class should be identical to the corresponding C++ class.
// This will make it easy for users of pony-sfml to understand existing
// SFML docs and examples.
//
// This class must not publicly expose any FFI types.
//
class BlendMode
    let _struct: _BlendMode

    // Access will be through getters/setters, below.
    // This is because we need to maintain the FFI struct when assignments are made.
    var _csf: _BMFact
    var _cdf: _BMFact
    var _ceq: _BMEqtn
    var _asf: _BMFact
    var _adf: _BMFact
    var _aeq: _BMEqtn
    
    new create(
        colorSrcFactor: BlendModeFactor, 
        colorDstFactor: BlendModeFactor, 
        colorEquation:  BlendModeEquation, 
        alphaSrcFactor: BlendModeFactor, 
        alphaDstFactor: BlendModeFactor, 
        alphaEquation : BlendModeEquation)
    =>
        _csf = colorSrcFactor
        _cdf = colorDstFactor
        _ceq = colorEquation
        _asf = alphaSrcFactor
        _adf = alphaDstFactor
        _aeq = alphaEquation
        _struct = _BlendMode(_csf, _cdf, _ceq, _asf, _adf, _aeq)

    new none() =>      
        _csf = FactorOne ; _cdf = FactorZero ; _ceq = EquationAdd
        _asf = FactorOne ; _adf = FactorZero ; _aeq = EquationAdd      
        _struct = _BlendMode(_csf, _cdf, _ceq, _asf, _adf, _aeq)

    new alpha() =>
        _csf = FactorSrcAlpha ; _cdf = FactorOneMinusSrcAlpha ; _ceq = EquationAdd
        _asf = FactorOne      ; _adf = FactorOneMinusSrcAlpha ; _aeq = EquationAdd
        _struct = _BlendMode(_csf, _cdf, _ceq, _asf, _adf, _aeq)

    new add() =>
        _csf = FactorSrcAlpha ; _cdf = FactorOne ; _ceq = EquationAdd
        _asf = FactorOne      ; _adf = FactorOne ; _aeq = EquationAdd
        _struct = _BlendMode(_csf, _cdf, _ceq, _asf, _adf, _aeq)

    new multiply() =>
        _csf = FactorDstColor ; _cdf = FactorZero ; _ceq = EquationAdd
        _asf = FactorDstColor ; _adf = FactorZero ; _aeq = EquationAdd
        _struct = _BlendMode(_csf, _cdf, _ceq, _asf, _adf, _aeq)

    fun ref _getStruct(): _BlendMode => _struct

    // Pony Wishlist: desugar r.x to r.getX() if x is not a member var but getX method exists.
    fun box getColorSrcFactor(): BlendModeFactor box   => _csf
    fun box getColorDstFactor(): BlendModeFactor box   => _cdf
    fun box getColorEquation():  BlendModeEquation box => _ceq
    fun box getAlphaSrcFactor(): BlendModeFactor box   => _asf
    fun box getAlphaDstFactor(): BlendModeFactor box   => _adf
    fun box getAlphaEquation():  BlendModeEquation box => _aeq

    // Pony Wishlist: desugar r.x=v to r.setX(v) if x is not a member var but setX method exists.
    fun ref setColorSrcFactor(x: BlendModeFactor)   => _csf = x ; _struct.csf = x._i32()
    fun ref setColorDstFactor(x: BlendModeFactor)   => _cdf = x ; _struct.cdf = x._i32()
    fun ref setColorEquation(x:  BlendModeEquation) => _ceq = x ; _struct.ceq = x._i32()
    fun ref setAlphaSrcFactor(x: BlendModeFactor)   => _asf = x ; _struct.asf = x._i32()
    fun ref setAlphaDstFactor(x: BlendModeFactor)   => _adf = x ; _struct.adf = x._i32()
    fun ref setAlphaEquation(x:  BlendModeEquation) => _aeq = x ; _struct.aeq = x._i32()


trait val _BMEqtn fun _i32(): I32  
primitive EquationAdd             is _BMEqtn fun _i32(): I32 => 0 
primitive EquationSubtract        is _BMEqtn fun _i32(): I32 => 1
primitive EquationReverseSubtract is _BMEqtn fun _i32(): I32 => 2
type BlendModeEquation is _BMEqtn // This alias will be used in API signatures.

trait val _BMFact fun _i32(): I32
primitive FactorZero             is _BMFact fun _i32(): I32 => 0 
primitive FactorOne              is _BMFact fun _i32(): I32 => 1 
primitive FactorSrcColor         is _BMFact fun _i32(): I32 => 2          
primitive FactorOneMinusSrcColor is _BMFact fun _i32(): I32 => 3  
primitive FactorDstColor         is _BMFact fun _i32(): I32 => 4          
primitive FactorOneMinusDstColor is _BMFact fun _i32(): I32 => 5  
primitive FactorSrcAlpha         is _BMFact fun _i32(): I32 => 6          
primitive FactorOneMinusSrcAlpha is _BMFact fun _i32(): I32 => 7  
primitive FactorDstAlpha         is _BMFact fun _i32(): I32 => 8          
primitive FactorOneMinusDstAlpha is _BMFact fun _i32(): I32 => 9
type BlendModeFactor is _BMFact // This alias will be used in API signatures.         

