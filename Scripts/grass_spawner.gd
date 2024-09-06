extends Node2D

class_name GrassSpawner

@export var grasses: Array[Texture2D] = []

@onready var manager: GameManager = get_tree().root.get_node("Farm")
@onready var timer: Timer = $Timer

var grass := preload("res://Scenes/grass.tscn")
var grass_count: int = 0
var grass_affected_count: int = 0: set=set_grass_affected_count

func _ready() -> void:
  spawn_grass(0.6, 100, 1220)

func spawn_grass(density: float, start: float, end: float) -> void:
  var i: float = start
  while i < end:
    if randf() < density:
      var new_grass: Node2D = grass.instantiate()
      new_grass.position = Vector2(i, 0)
      new_grass.scale = Vector2.ONE * randf_range(0.8, 1.2)
      new_grass.get_node("Plant").texture = grasses[randi_range(0, grasses.size() - 1)]
      add_child(new_grass)
      grass_count += 1
    i += 0.5

func set_grass_affected_count(new_value: int) -> void:
  grass_affected_count = new_value
  timer.start()

func _on_timer_timeout() -> void:
  match manager.state:
    GameManager.GameStates.Cut:
      if grass_count == grass_affected_count:
        manager.state = GameManager.GameStates.Ted
        grass_affected_count = 0
    GameManager.GameStates.Ted:
      if grass_count * 0.98 < grass_affected_count:
        manager.state = GameManager.GameStates.Bale
        grass_affected_count = 0
    GameManager.GameStates.Bale:
      if grass_count == grass_affected_count:
        manager.state = GameManager.GameStates.Stack
        grass_affected_count = 0
