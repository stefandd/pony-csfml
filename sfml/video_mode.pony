// 
// The SFML object as presented by CSFML
// 
// Because CSFML DOES NOT provide functions to create this structure, we will 
// be allocating them here, in pony-sfml. The only constraint on this private
// struct is that it needs to match the memory layout of the corresponding 
// sfRenderStates in CSFML. Its methods can be *anything* useful to the private
// implementation of pony-sfml.
//
struct _VideoMode
  let width: U32        // Video mode width, in pixels
  let height: U32       // Video mode height, in pixels
  let bitsPerPixel: U32 // Video mode pixel depth, in bits per pixels

  new create(w: U32, h: U32, depth: U32) =>
    width = w
    height = h
    bitsPerPixel = depth

//
// A proxy class that abstracts away CSFML and FFI and presents a clean Pony API.
//
class VideoMode

  let _videoMode: _VideoMode ref

  new create(w: U32, h: U32, depth: U32) =>
    _videoMode = _VideoMode(w, h, depth)

  fun getWidth(): U32 => 
    _videoMode.width

  fun getHeight(): U32 => 
    _videoMode.height
  
  fun getBitsPerPixel(): U32 => 
    _videoMode.bitsPerPixel

  fun ref _getCsfml(): _VideoMode =>
    _videoMode