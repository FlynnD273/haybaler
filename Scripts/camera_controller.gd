extends Camera2D

@export var target: Node2D
@export var speed: float = 2
@export var min_x: float = 0
@export var max_x: float = 600
@export var max_y: float = 20
@export var deadzone: float = 20

func _ready() -> void:
  if target:
    position = get_constrained_position()

func _physics_process(delta: float) -> void:
  if target:
    position += (get_constrained_position() - position) * (1 - exp(-speed * delta))

func get_constrained_position() -> Vector2:
  var target_position := target.position
  var view_w = get_viewport_rect().size.x / 2 / zoom.x
  var view_h = get_viewport_rect().size.y / 2 / zoom.y
  target_position.x = min(max(target_position.x, min_x + view_w), max_x - view_w)
  target_position.y = min(target_position.y, max_y - view_h)
  return target_position
