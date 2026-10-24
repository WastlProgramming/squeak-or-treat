extends CharacterBody2D


@export var speed := 500


func _ready() -> void:
	add_to_group("player")
	position = Vector2(100, 500)
	if GameState.selected_character == "boy":
		$Sprite2D.texture = load("res://assets/kids/base/kid_boy_idle.svg")
	else:
		$Sprite2D.texture = load("res://assets/kids/base/kid_girl_idle.svg")


func _process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "top", "down")
	velocity = direction * speed
	move_and_slide()
