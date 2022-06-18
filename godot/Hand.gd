extends Resource
class_name Hand

enum Side { LEFT, RIGHT }
enum Shape { FIST, FLAT, SPREAD, HANDLE, CLAW }
enum Anchor { NONE, CHEST, HEAD, FRONT_CENTER, FRONT_RIGHT, FRONT_LEFT }

export(Side) var side: int = Side.LEFT
export(Shape) var shape: int = Shape.FLAT

export(Anchor) var anchor: int
export(Vector3) var offset: Vector3
export(Vector3) var orientation: Vector3

export(Resource) var thumb
export(Resource) var index_finger
export(Resource) var middle_finger
export(Resource) var ring_finger
export(Resource) var little_finger

