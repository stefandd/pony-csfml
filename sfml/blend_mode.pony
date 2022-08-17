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
        csf': I32, cdf': I32, ceq': I32,
        asf': I32, adf': I32, aeq': I32)
    =>
        csf = csf' ; cdf = cdf' ; ceq = ceq'
        asf = asf' ; adf = adf' ; aeq = aeq'

    new copy(that: _BlendMode box) =>
        csf = that.csf ; cdf = that.cdf ; ceq = that.ceq
        asf = that.asf ; adf = that.adf ; aeq = that.aeq

    new none() =>
        csf = _BMFact.one() ; cdf = _BMFact.zero() ; ceq = _BMEqtn.add()
        asf = _BMFact.one() ; adf = _BMFact.zero() ; aeq = _BMEqtn.add()

    new alpha() =>
        csf = _BMFact.sa()  ; cdf = _BMFact.omsa() ; ceq = _BMEqtn.add()
        asf = _BMFact.one() ; adf = _BMFact.omsa() ; aeq = _BMEqtn.add()

    new add() =>
        csf = _BMFact.sa()  ; cdf = _BMFact.one()  ; ceq = _BMEqtn.add()
        asf = _BMFact.one() ; adf = _BMFact.one()  ; aeq = _BMEqtn.add()

    new multiply() =>
        csf = _BMFact.dc()  ; cdf = _BMFact.zero() ; ceq = _BMEqtn.add()
        asf = _BMFact.dc()  ; adf = _BMFact.zero() ; aeq = _BMEqtn.add()

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
            colorSrcFactor._i32(), colorDstFactor._i32(), colorEquation._i32(),
            alphaSrcFactor._i32(), alphaDstFactor._i32(), alphaEquation._i32() )

    new none()     => _csfml = _BlendMode.none()
    new alpha()    => _csfml = _BlendMode.alpha()
    new add()      => _csfml = _BlendMode.add()
    new multiply() => _csfml = _BlendMode.multiply()

    new _fromCsfml(bm: _BlendMode) => _csfml = bm

    fun ref _getCsfml(): _BlendMode => _csfml

    // Pony Wishlist: desugar r.x to r.getX() if x is not a member var but getX method exists.
    fun box getColorSrcFactor(): BlendModeFactor   => BlendModeFactor._from_i32(_csfml.csf)
    fun box getColorDstFactor(): BlendModeFactor   => BlendModeFactor._from_i32(_csfml.cdf)
    fun box getColorEquation():  BlendModeEquation => BlendModeEquation._from_i32(_csfml.ceq)
    fun box getAlphaSrcFactor(): BlendModeFactor   => BlendModeFactor._from_i32(_csfml.asf)
    fun box getAlphaDstFactor(): BlendModeFactor   => BlendModeFactor._from_i32(_csfml.adf)
    fun box getAlphaEquation():  BlendModeEquation => BlendModeEquation._from_i32(_csfml.aeq)

    // Pony Wishlist: desugar r.x=v to r.setX(v) if x is not a member var but setX method exists.
    //fun ref setColorSrcFactor(f: BlendModeFactor)   => _csfml.csf = f._i32()
    //fun ref setColorDstFactor(f: BlendModeFactor)   => _csfml.cdf = f._i32()
    //fun ref setColorEquation( e: BlendModeEquation) => _csfml.ceq = e._i32()
    //fun ref setAlphaSrcFactor(f: BlendModeFactor)   => _csfml.asf = f._i32()
    //fun ref setAlphaDstFactor(f: BlendModeFactor)   => _csfml.adf = f._i32()
    //fun ref setAlphaEquation( e: BlendModeEquation) => _csfml.aeq = e._i32()


//
// Related "enumerations"
//

primitive _BMEqtn
    fun add(): I32 => 0
    fun sub(): I32 => 1
    fun rev(): I32 => 2

class BlendModeEquation
    let _val: I32
    
    new add()             => _val = _BMEqtn.add()
    new subtract()        => _val = _BMEqtn.sub()
    new reverseSubtract() => _val = _BMEqtn.rev()

    fun isAdd():             Bool => _val == _BMEqtn.add()
    fun isSubtract():        Bool => _val == _BMEqtn.sub()
    fun isReverseSubtract(): Bool => _val == _BMEqtn.rev()

    new _from_i32(i32: I32) => _val = i32
    fun _i32(): I32 => _val

primitive _BMFact
    fun zero(): I32 => 0   // Zero
    fun one():  I32 => 1   // One
    fun sc():   I32 => 2   // Src Color
    fun omsc(): I32 => 3   // One Minus SrcColor
    fun dc():   I32 => 4   // Dst Color
    fun omdc(): I32 => 5   // One Minus Dst Color
    fun sa():   I32 => 6   // Src Alpha
    fun omsa(): I32 => 7   // One Minus Src Alpha
    fun da():   I32 => 8   // Dst Alpha
    fun omda(): I32 => 9   // One Minus Dst Alpha

class BlendModeFactor
    let _val: I32

    new zero()             => _val = _BMFact.zero()
    new one()              => _val = _BMFact.one()
    new srcColor()         => _val = _BMFact.sc()
    new oneMinusSrcColor() => _val = _BMFact.omsc()
    new dstColor()         => _val = _BMFact.dc()
    new oneMinusDstColor() => _val = _BMFact.omdc()
    new srcAlpha()         => _val = _BMFact.sa()
    new oneMinusSrcAlpha() => _val = _BMFact.omsa()
    new dstAlpha()         => _val = _BMFact.da()
    new oneMinusDstAlpha() => _val = _BMFact.omda()

    fun isZero():             Bool => _val == _BMFact.zero()
    fun isOne():              Bool => _val == _BMFact.one()
    fun isSrcColor():         Bool => _val == _BMFact.sc()
    fun isOneMinusSrcColor(): Bool => _val == _BMFact.omsc()
    fun isDstColor():         Bool => _val == _BMFact.dc()
    fun isOneMinusDstColor(): Bool => _val == _BMFact.omdc()
    fun isSrcAlpha():         Bool => _val == _BMFact.sa()
    fun isOneMinusSrcAlpha(): Bool => _val == _BMFact.omsa()
    fun isDstAlpha():         Bool => _val == _BMFact.da()
    fun isOneMinusDstAlpha(): Bool => _val == _BMFact.omda()

    new _from_i32(i32: I32) => _val = i32
    fun _i32(): I32 => _val
