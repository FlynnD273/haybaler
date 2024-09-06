extends Node2D

@export var bale_parent: Node

@onready var manager: GameManager = get_tree().root.get_node("Farm")

var movable_bale: PackedScene = preload("res://Scenes/movable_bale.tscn")
@onready var hitbox = $Area2D
@onready var bale = $Sprite2D

var size: float = 0: set = _set_size

func _process(_delta: float) -> void:
  bale.rotation = global_position.x * scale.x

func set_hitbox_disabled(is_disabled: bool) -> void:
  for child in hitbox.get_children():
    if child is CollisionShape2D:
      child.disabled = is_disabled


func grow() -> void:
  size += 0.01

  if size >= 1:
    create_bale()

func create_bale() -> void:
  size = 0
  var new_bale: RigidBody2D = movable_bale.instantiate()
  new_bale.position = global_position
  new_bale.rotation = bale.rotation
  new_bale.linear_velocity.y = -200
  new_bale.angular_velocity = 5
  bale_parent.add_child.call_deferred(new_bale)

func _on_farm_state_changed() -> void:
  match manager.state:
    GameManager.GameStates.Bale:
      bale.show()
      set_hitbox_disabled.call_deferred(false)
      size = 0
    _:
      if size > 0.2:
        create_bale()
      set_hitbox_disabled.call_deferred(true)
      bale.hide()

func _set_size(newvalue: float) -> void:
  size = newvalue
  bale.scale = Vector2(size, size)
