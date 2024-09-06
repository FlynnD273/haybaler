extends Node2D

@export var reach: float = 2

@onready var timer: Timer = $Timer
@onready var hitbox: Area2D = $Hitbox
@onready var graphic: Sprite2D = $ScytheGraphic
@onready var manager: GameManager = get_tree().root.get_node("Farm")

var start_x: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  timer.connect("timeout", end_slice)

  set_hitbox_disabled(true)
  start_x = hitbox.scale.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  if visible and timer.is_stopped() and Input.is_action_just_pressed("use"):
    slice()

func set_hitbox_disabled(is_disabled: bool) -> void:
  for child in hitbox.get_children():
    if child is CollisionShape2D:
      child.disabled = is_disabled

func slice() -> void:
  timer.start()
  graphic.hide()
  set_hitbox_disabled(false)
  hitbox.scale.x = start_x
  var tween := create_tween()
  tween.tween_property(hitbox, "scale", Vector2(start_x + reach, hitbox.scale.y), timer.wait_time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func end_slice() -> void:
  graphic.show()
  set_hitbox_disabled(true)

func _on_farm_state_changed() -> void:
  match manager.state:
    GameManager.GameStates.Cut:
      show()
    _:
      hide()
