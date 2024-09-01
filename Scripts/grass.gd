extends Area2D

enum GrassStates {
  Whole,
  Cut,
  Tedded,
}

var state := GrassStates.Whole

var stub := preload("res://Scenes/stub.tscn")

@onready var plant: Sprite2D = $Plant
@onready var parent: GrassSpawner = get_parent()

func _on_area_entered(area: Area2D) -> void:
  if state == GrassStates.Whole and area.get_parent().name == "Scythe":
    state = GrassStates.Cut
    var new_stub: Node2D = stub.instantiate()
    new_stub.position = position
    new_stub.scale = scale
    parent.add_child(new_stub)
    parent.grass_affected_count += 1
    var tween := create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    var new_rot: float = -90 if randf() < 0.5 else 90
    new_rot += randf_range(-10, 10)
    tween.tween_property(self, "rotation_degrees", new_rot, 0.1)
    tween.tween_property(self, "position", Vector2(position.x + randf_range(-40, 40), position.y - randf_range(3, 5)), 0.1)

  elif (state == GrassStates.Cut or state == GrassStates.Tedded) and area.get_parent().name == "Tedder":
    var tween := create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    var new_rot: float = rotation_degrees + randf_range(-10, 10)
    tween.tween_property(self, "rotation_degrees", new_rot, 0.1)
    tween.tween_property(self, "position", Vector2(position.x + randf_range(-40, 40), position.y - randf_range(3, 5)), 0.1)
    tween.tween_property(plant, "modulate", Color.from_hsv(33 / 360.0, 64 / 100.0, 78 / 100.0), 10)

    if state == GrassStates.Cut:
      parent.grass_affected_count += 1
      state = GrassStates.Tedded
