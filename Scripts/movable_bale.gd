extends RigidBody2D

class_name MovableBale

var prev_pos: Vector2 = Vector2.ZERO
var delta_pos: Vector2 = Vector2.ZERO

func _physics_process(_delta: float) -> void:
  delta_pos = position - prev_pos
  prev_pos = position
