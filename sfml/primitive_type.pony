

primitive Points          fun apply(): I32 => 0
primitive Lines           fun apply(): I32 => 1
primitive LineStrip       fun apply(): I32 => 2
primitive Triangles       fun apply(): I32 => 3
primitive TriangleStrip   fun apply(): I32 => 4
primitive TriangleFan     fun apply(): I32 => 5
primitive Quads           fun apply(): I32 => 6

// REVIEW: There's no legacy Pony code that uses these 
// deprecated names, so we probably shouldn't offer them.
//
// primitive \deprecated\ LinesStrip     fun apply(): I32 => 2
// primitive \deprecated\ TrianglesStrip fun apply(): I32 => 4
// primitive \deprecated\ TrianglesFan   fun apply(): I32 => 5

type PrimitiveType is
    ( Points
    | Lines
    | LineStrip
    | Triangles
    | TriangleStrip
    | TriangleFan
    | Quads )

