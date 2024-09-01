extends RichTextLabel
@onready var manager: GameManager = get_tree().root.get_node("Farm")

func _on_farm_state_changed() -> void:
  if manager.state == GameManager.GameStates.Ted:
    text = "Great job! Now you need to ted the grass to let it dry better."
