extends CharacterBody2D


@export var speed := 80.0


func _ready() -> void:
	add_to_group("monster")


func _physics_process(_delta: float) -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		velocity = Vector2.ZERO
	else:
		velocity = (player.global_position - global_position).normalized() * speed
	move_and_slide()
