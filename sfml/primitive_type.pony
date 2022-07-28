
trait val PrimitiveType
    fun _i32(): I32  // For CSFML FFI

primitive Points is PrimitiveType         fun _i32(): I32 => 0
primitive Lines is PrimitiveType          fun _i32(): I32 => 1
primitive LineStrip is PrimitiveType      fun _i32(): I32 => 2
primitive Triangles is PrimitiveType      fun _i32(): I32 => 3
primitive TriangleStrip is PrimitiveType  fun _i32(): I32 => 4
primitive TriangleFan is PrimitiveType    fun _i32(): I32 => 5
primitive Quads is PrimitiveType          fun _i32(): I32 => 6

primitive \deprecated\ LinesStrip is PrimitiveType     fun _i32(): I32 => 2
primitive \deprecated\ TrianglesStrip is PrimitiveType fun _i32(): I32 => 4
primitive \deprecated\ TrianglesFan is PrimitiveType   fun _i32(): I32 => 5

// Example of correlation between C++ API and Pony API:
// C++:  vertices.setPrimitiveType(sf::Quads);
// Pony: vertices.setPrimitiveType(sf.Quads)

