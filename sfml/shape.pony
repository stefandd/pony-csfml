

// REVIEW: Would it be better to have _RectangleShapeRaw and _CircleShapeRaw?
// (See comments in CircleShape and RectangleShape for related REVIEW comments)
// This might not be possible in Pony because Pony structs cannot participate 
// in union types.

struct _Shape
type ShapeRaw is NullablePointer[_Shape]

type Shape is (CircleShape | RectangleShape)

