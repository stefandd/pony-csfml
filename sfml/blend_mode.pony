use @fprintf[I32](stream: Pointer[U8] tag, fmt: Pointer[U8] tag, ...)
use @pony_os_stdout[Pointer[U8]]()
use @pony_os_stderr[Pointer[U8]]()
use @exit[None](code: I32)

//
// The SFML object as presented by CSFML
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
        csf = csf'() ; cdf = cdf'() ; ceq = ceq'()
        asf = asf'() ; adf = adf'() ; aeq = aeq'()

    new copy(that: _BlendMode box) =>
        csf = that.csf ; cdf = that.cdf ; ceq = that.ceq
        asf = that.asf ; adf = that.adf ; aeq = that.aeq

    new none() =>
        csf = FactorOne() ; cdf = FactorZero() ; ceq = EquationAdd()
        asf = FactorOne() ; adf = FactorZero() ; aeq = EquationAdd()

    new alpha() =>
        csf = FactorSrcAlpha() ; cdf = FactorOneMinusSrcAlpha() ; ceq = EquationAdd()
        asf = FactorOne()      ; adf = FactorOneMinusSrcAlpha() ; aeq = EquationAdd()

    new add() =>
        csf = FactorSrcAlpha() ; cdf = FactorOne() ; ceq = EquationAdd()
        asf = FactorOne()      ; adf = FactorOne() ; aeq = EquationAdd()

    new multiply() =>
        csf = FactorDstColor() ; cdf = FactorZero() ; ceq = EquationAdd()
        asf = FactorDstColor() ; adf = FactorZero() ; aeq = EquationAdd()

    fun ref setFrom(that: _BlendMode) =>
        csf = that.csf ; cdf = that.cdf ; ceq = that.ceq
        asf = that.asf ; adf = that.adf ; aeq = that.aeq

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class BlendMode
    let _csfml: _BlendMode

    new create(
        colorSrcFactor: BlendModeFactor,
        colorDstFactor: BlendModeFactor,
        colorEquation:  BlendModeEquation,
        alphaSrcFactor: BlendModeFactor,
        alphaDstFactor: BlendModeFactor,
        alphaEquation : BlendModeEquation)
    =>
        _csfml = _BlendMode(
            colorSrcFactor, colorDstFactor, colorEquation,
            alphaSrcFactor, alphaDstFactor, alphaEquation )


    new none()     => _csfml = _BlendMode.none()
    new alpha()    => _csfml = _BlendMode.alpha()
    new add()      => _csfml = _BlendMode.add()
    new multiply() => _csfml = _BlendMode.multiply()

    new _fromCsfml(bm: _BlendMode) => _csfml = bm

    fun ref _getCsfml(): _BlendMode => _csfml

    // Pony Wishlist: desugar r.x to r.getX() if x is not a member var but getX method exists.
    fun box getColorSrcFactor(): BlendModeFactor box   => _I32toFactor(_csfml.csf)
    fun box getColorDstFactor(): BlendModeFactor box   => _I32toFactor(_csfml.cdf)
    fun box getColorEquation():  BlendModeEquation box => _I32toEquation(_csfml.ceq)
    fun box getAlphaSrcFactor(): BlendModeFactor box   => _I32toFactor(_csfml.asf)
    fun box getAlphaDstFactor(): BlendModeFactor box   => _I32toFactor(_csfml.adf)
    fun box getAlphaEquation():  BlendModeEquation box => _I32toEquation(_csfml.aeq)

    // Pony Wishlist: desugar r.x=v to r.setX(v) if x is not a member var but setX method exists.
    fun ref setColorSrcFactor(f: BlendModeFactor)   => _csfml.csf = f()
    fun ref setColorDstFactor(f: BlendModeFactor)   => _csfml.cdf = f()
    fun ref setColorEquation(e:  BlendModeEquation) => _csfml.ceq = e()
    fun ref setAlphaSrcFactor(f: BlendModeFactor)   => _csfml.asf = f()
    fun ref setAlphaDstFactor(f: BlendModeFactor)   => _csfml.adf = f()
    fun ref setAlphaEquation(e:  BlendModeEquation) => _csfml.aeq = e()

primitive EquationAdd             fun apply(): I32 => 0
primitive EquationSubtract        fun apply(): I32 => 1
primitive EquationReverseSubtract fun apply(): I32 => 2

primitive FactorZero              fun apply(): I32 => 0
primitive FactorOne               fun apply(): I32 => 1
primitive FactorSrcColor          fun apply(): I32 => 2
primitive FactorOneMinusSrcColor  fun apply(): I32 => 3
primitive FactorDstColor          fun apply(): I32 => 4
primitive FactorOneMinusDstColor  fun apply(): I32 => 5
primitive FactorSrcAlpha          fun apply(): I32 => 6
primitive FactorOneMinusSrcAlpha  fun apply(): I32 => 7
primitive FactorDstAlpha          fun apply(): I32 => 8
primitive FactorOneMinusDstAlpha  fun apply(): I32 => 9

type BlendModeEquation is
    ( EquationAdd
    | EquationSubtract
    | EquationReverseSubtract)

type BlendModeFactor is
    ( FactorZero
    | FactorOne
    | FactorSrcColor
    | FactorOneMinusSrcColor
    | FactorDstColor
    | FactorOneMinusDstColor
    | FactorSrcAlpha
    | FactorOneMinusSrcAlpha
    | FactorDstAlpha
    | FactorOneMinusDstAlpha)

type _BMEqtn is BlendModeEquation

type _BMFact is BlendModeFactor

// The reverse mappings, below, *should* be total functions but this is
// not possible in Pony because it (and most other languages) don't have
// refinement types. 
//
// Any failure of these reverse mappings will be due to a programming error
// that needs to be fixed, so we'll just print an error message and kill the
// process.

primitive _I32toEquation
    fun apply(x: I32): _BMEqtn =>
        match x
        | EquationAdd()             => EquationAdd                        
        | EquationSubtract()        => EquationSubtract              
        | EquationReverseSubtract() => EquationReverseSubtract
        else
            let stderr = @pony_os_stderr()
            @fprintf(stderr, "Bad state detected in _I32toEquation".cstring())
            @exit(1)
            EquationAdd // Never get here, but this satisfies the compiler's type checking.
        end

primitive _I32toFactor
    fun apply(x: I32): _BMFact =>
        match x
        | FactorZero()             => FactorZero            
        | FactorOne()              => FactorOne             
        | FactorSrcColor()         => FactorSrcColor        
        | FactorOneMinusSrcColor() => FactorOneMinusSrcColor
        | FactorDstColor()         => FactorDstColor        
        | FactorOneMinusDstColor() => FactorOneMinusDstColor
        | FactorSrcAlpha()         => FactorSrcAlpha        
        | FactorOneMinusSrcAlpha() => FactorOneMinusSrcAlpha
        | FactorDstAlpha()         => FactorDstAlpha        
        | FactorOneMinusDstAlpha() => FactorOneMinusDstAlpha
        else
            let stderr = @pony_os_stderr()
            @fprintf(stderr, "Bad state detected in _I32toFactor".cstring())
            @exit(1)
            FactorZero // Never get here, but this satisfies the compiler's type checking.        
        end            