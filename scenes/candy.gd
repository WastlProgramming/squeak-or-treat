extends CharacterBody2D

const CANDY_SCENE: PackedScene = preload("res://scenes/candy.tscn")
const VARIANTS : Array[StringName] = [
	 &""
]

func _process(delta: float) -> void:
	pass
	
func spawn_candy(pos: Vector2) -> void:
	var candy : CharacterBody2D = CANDY_SCENE.instantiate()
	candy.position = pos
	add_child(candy)
