extends Parallax2D
@onready var manager: GameManager = get_tree().root.get_node("Farm")
@onready var text: RichTextLabel = $Instructions

func _on_farm_state_changed() -> void:
  match manager.state:
    GameManager.GameStates.Cut:
      text.text = "Cut all the grass! Press <space> to use the tool."
    GameManager.GameStates.Ted:
      text.text = "Great job! Now you need to ted the grass to let it dry better."
    GameManager.GameStates.Bale:
      text.text = "Time to bale the hay!"
    GameManager.GameStates.Stack:
      text.text = "Pick up and stack all the hay in the barn!"
    GameManager.GameStates.Done:
      scroll_offset.x = 750
      text.text = "That's everything! Congratulations!"
