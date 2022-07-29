
struct BlendMode
    let colorSrcFactor: I32  ///< Source blending factor for the color channels
    let colorDstFactor: I32  ///< Destination blending factor for the color channels
    let colorEquation: I32   ///< Blending equation for the color channels
    let alphaSrcFactor: I32  ///< Source blending factor for the alpha channel
    let alphaDstFactor: I32  ///< Destination blending factor for the alpha channel
    let alphaEquation: I32   ///< Blending equation for the alpha channel

    new create(cSf: I32, cDf: I32, cE: I32, aSf: I32, aDf: I32, aE: I32) =>
        colorSrcFactor = cSf
        colorDstFactor = cDf
        colorEquation = cE
        alphaSrcFactor = aSf
        alphaDstFactor = aDf
        alphaEquation = aE

    new copy(that: BlendMode) =>
        colorSrcFactor = that.colorSrcFactor
        colorDstFactor = that.colorDstFactor
        colorEquation  = that.colorEquation
        alphaSrcFactor = that.alphaSrcFactor
        alphaDstFactor = that.alphaDstFactor
        alphaEquation  = that.alphaEquation

    new blendNone() =>
        colorSrcFactor = BlendFactor.one()
        colorDstFactor = BlendFactor.zero()
        colorEquation  = BlendEquation.add()
        alphaSrcFactor = BlendFactor.one()
        alphaDstFactor = BlendFactor.zero()
        alphaEquation  = BlendEquation.add()

    new blendAlpha() =>
        colorSrcFactor = BlendFactor.srcAlpha()
        colorDstFactor = BlendFactor.oneMinusSrcAlpha()
        colorEquation  = BlendEquation.add()
        alphaSrcFactor = BlendFactor.one()
        alphaDstFactor = BlendFactor.oneMinusSrcAlpha()
        alphaEquation  = BlendEquation.add()
    
    new blendAdd() =>
        colorSrcFactor = BlendFactor.srcAlpha()
        colorDstFactor = BlendFactor.one()
        colorEquation  = BlendEquation.add()
        alphaSrcFactor = BlendFactor.one()
        alphaDstFactor = BlendFactor.one()
        alphaEquation  = BlendEquation.add()
    
    new blendMultiply() =>
        colorSrcFactor = BlendFactor.dstColor()
        colorDstFactor = BlendFactor.zero()
        colorEquation  = BlendEquation.add()
        alphaSrcFactor = BlendFactor.dstColor()
        alphaDstFactor = BlendFactor.zero()
        alphaEquation  = BlendEquation.add()

type BlendModeRaw is NullablePointer[BlendMode]


primitive BlendEquation
    fun add(): I32 => 0  ///< Pixel = Src * SrcFactor + Dst * DstFactor
    fun subtract(): I32 => 1 ///< Pixel = Src * SrcFactor - Dst * DstFactor
    fun reverseSubtract(): I32 => 2  ///< Pixel = Dst * DstFactor - Src * SrcFactor

primitive BlendFactor
    fun zero(): I32 => 0              ///< (0, 0, 0, 0)
    fun one(): I32 => 1               ///< (1, 1, 1, 1)
    fun srcColor(): I32 => 2          
    fun oneMinusSrcColor(): I32 => 3  
    fun dstColor(): I32 => 4          
    fun oneMinusDstColor(): I32 => 5  
    fun srcAlpha(): I32 => 6          
    fun oneMinusSrcAlpha(): I32 => 7  
    fun dstAlpha(): I32 => 8          
    fun oneMinusDstAlpha (): I32 => 9
