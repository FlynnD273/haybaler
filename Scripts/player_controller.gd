extends CharacterBody2D

class_name PlayerController

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

@onready var farmer: Sprite2D = $Farmer
@onready var roll: Sprite2D = $RollingFarmer
@onready var tools: Node2D = $Tools
@onready var manager: GameManager = get_tree().root.get_node("Farm")

var held_bale: MovableBale = null
var in_reach_bale: Array[MovableBale] = []


func _physics_process(delta: float) -> void:
  # Add the gravity.
  if not is_on_floor():
    velocity += get_gravity() * delta

  var direction := Input.get_axis("left", "right")
  if direction:
    velocity.x = direction * SPEED
    farmer.flip_h = direction < 0
    tools.scale.x = -1 if direction < 0 else 1
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)

  if manager.state == GameManager.GameStates.Stack or manager.state == GameManager.GameStates.Done:
    if Input.is_action_just_pressed("use"):
      if held_bale == null:
        if in_reach_bale.size() > 0:
          held_bale = in_reach_bale[0]
      else:
        held_bale.linear_velocity = Vector2(-300 if farmer.flip_h else 300, -300)
        held_bale.angular_velocity = -5 if farmer.flip_h else 5
        held_bale = null

  if held_bale:
    held_bale.position = Vector2(position.x, position.y - 50)
    held_bale.linear_velocity = Vector2.ZERO

  move_and_slide()

func _on_farm_state_changed() -> void:
  match manager.state:
    GameManager.GameStates.Bale:
      farmer.hide()
      roll.show()
    _:
      held_bale = null
      in_reach_bale = []
      farmer.show()
      roll.hide()
  if manager.state != GameManager.GameStates.Done:
    reset_position.call_deferred()

func reset_position() -> void:
  position.x = 0


func _on_area_2d_area_entered(area: Area2D) -> void:
  if manager.state != GameManager.GameStates.Stack and manager.state != GameManager.GameStates.Done:
    return
  var item = area.get_parent()
  if item is MovableBale:
    in_reach_bale.append(item)


func _on_area_2d_area_exited(area: Area2D) -> void:
  if manager.state != GameManager.GameStates.Stack and manager.state != GameManager.GameStates.Done:
    return
  var item = area.get_parent()
  if item is MovableBale:
    var index := -1
    for i in range(in_reach_bale.size()):
      if in_reach_bale[i] == item:
        index = i
    if index >= 0:
      in_reach_bale.remove_at(index)
