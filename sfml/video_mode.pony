
struct VideoMode
    let width: U32        // Video mode width, in pixels
    let height: U32       // Video mode height, in pixels
    let bitsPerPixel: U32 // Video mode pixel depth, in bits per pixels

    new create(w: U32, h: U32, depth: U32) =>
        width = w
        height = h
        bitsPerPixel = depth

type VideoModeRaw is NullablePointer[VideoMode]
