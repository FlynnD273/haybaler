extends Node2D

class_name GrassSpawner

@export var grasses: Array[Texture2D] = []

@onready var manager: GameManager = get_tree().root.get_node("Farm")

var grass := preload("res://Scenes/grass.tscn")
var grass_count: int = 0
var grass_affected_count: int = 0: set=set_grass_affected_count

func _ready() -> void:
  spawn_grass(0.8, 50, 2000)

func spawn_grass(density: float, start: float, end: float) -> void:
  for i in range(start, end):
    if randf() < density:
      var new_grass: Node2D = grass.instantiate()
      new_grass.position = Vector2(i, 0)
      new_grass.scale = Vector2.ONE * randf_range(0.8, 1.2)
      new_grass.get_node("Plant").texture = grasses[randi_range(0, grasses.size() - 1)]
      add_child(new_grass)
      grass_count += 1

func set_grass_affected_count(new_value: int) -> void:
  grass_affected_count = new_value
  match manager.state:
    GameManager.GameStates.Cut:
      if grass_count == grass_affected_count:
        manager.state = GameManager.GameStates.Ted
        grass_affected_count = 0
    GameManager.GameStates.Ted:
      if grass_count * 0.95 < grass_affected_count:
        manager.state = GameManager.GameStates.Bale
        grass_affected_count = 0
