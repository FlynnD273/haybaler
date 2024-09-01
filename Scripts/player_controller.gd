extends CharacterBody2D


@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

@onready var farmer: Sprite2D = $Farmer
@onready var tools: Node2D = $Tools
@onready var manager: GameManager = get_tree().root.get_node("Farm")


func _physics_process(delta: float) -> void:
  # Add the gravity.
  if not is_on_floor():
    velocity += get_gravity() * delta

  # if Input.is_action_just_pressed("jump") and is_on_floor():
  #   velocity.y = JUMP_VELOCITY

  var direction := Input.get_axis("left", "right")
  if direction:
    velocity.x = direction * SPEED
    farmer.flip_h = direction < 0
    tools.scale.x = -1 if direction < 0 else 1
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)

  move_and_slide()

func _on_farm_state_changed() -> void:
  position.x = 0
