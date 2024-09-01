extends Node2D

class_name GameManager

enum GameStates {
  Cut,
  Ted,
  Bale,
  Stack,
  Done,
}

var state: GameStates = GameStates.Cut: set=_set_state

signal state_changed

func _set_state(new_value: GameStates) -> void:
  if new_value != state:
    state = new_value
    print("New state ", GameStates.keys()[state])
    state_changed.emit()
