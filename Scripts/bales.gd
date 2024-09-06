extends Node2D

var could_be_done := false
var bales: Array[MovableBale] = []
@onready var manager: GameManager = get_tree().root.get_node("Farm")
@export var player: PlayerController = null

func check_bales() -> bool:
  if (manager.state != GameManager.GameStates.Stack and manager.state != GameManager.GameStates.Done) or player.held_bale:
    return false
  for bale in bales:
    if bale.position.x < $"../Bounds/BarnThreshold".position.x or bale.linear_velocity.length_squared() > 1:
      return false
  return true

func _physics_process(_delta: float) -> void:
  if bales:
    # print(bales[0].linear_velocity)
    if not could_be_done:
      could_be_done = check_bales()
      if could_be_done:
        $Timer.start()
    else:
      could_be_done = check_bales()


func _on_farm_state_changed() -> void:
  if manager.state == GameManager.GameStates.Stack or manager.state == GameManager.GameStates.Done:
    bales = []
    for child in get_children():
      if child is MovableBale:
        bales.append(child)


func _on_timer_timeout() -> void:
  if check_bales():
    manager.state = GameManager.GameStates.Done
