extends CharacterBody2D


@export var base_speed: int = 500
var speed: float = float(base_speed)
var _boost_time_left: float = 0.0


func _ready() -> void:
	add_to_group("player")
	speed = float(base_speed)
	position = Vector2(100, 500)
	if GameState.selected_character == "boy":
		$Sprite2D.texture = load("res://assets/kids/base/kid_boy_idle.svg")
	else:
		$Sprite2D.texture = load("res://assets/kids/base/kid_girl_idle.svg")


func _process(delta: float) -> void:
	if _boost_time_left > 0.0:
		_boost_time_left -= delta
		if _boost_time_left <= 0.0:
			speed = float(base_speed)

	var direction := Input.get_vector("left", "right", "top", "down")
	velocity = direction * speed
	move_and_slide()


func apply_speed_boost(multiplier: float, duration: float) -> void:
	speed = base_speed * (1.0 + multiplier)
	_boost_time_left = duration
