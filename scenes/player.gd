extends CharacterBody2D


signal candies_changed(count: int)
signal game_over


@export var base_speed: int = 500
@export var start_candies: int = 5
@export var drop_per_hit: int = 3
@export var hit_cooldown: float = 1.0

const CANDY_SCENE: PackedScene = preload("res://scenes/candy.tscn")

var speed: float = float(base_speed)
var candies: int = 0
var _boost_time_left: float = 0.0
var _hit_cd_left: float = 0.0
var _is_dead: bool = false


func _ready() -> void:
	add_to_group("player")
	speed = float(base_speed)
	position = Vector2(100, 500)
	if GameState.selected_character == "boy":
		$Sprite2D.texture = load("res://assets/kids/base/kid_boy_idle.svg")
	else:
		$Sprite2D.texture = load("res://assets/kids/base/kid_girl_idle.svg")

	candies = start_candies
	candies_changed.emit(candies)


func _process(delta: float) -> void:
	if _boost_time_left > 0.0:
		_boost_time_left -= delta
		if _boost_time_left <= 0.0:
			speed = float(base_speed)

	if _hit_cd_left > 0.0:
		_hit_cd_left -= delta

	var direction := Input.get_vector("left", "right", "top", "down")
	velocity = direction * speed
	move_and_slide()

	if not _is_dead and _hit_cd_left <= 0.0:
		for body in $Hitbox.get_overlapping_bodies():
			if body.is_in_group("monster"):
				_take_hit()
				break


func apply_speed_boost(multiplier: float, duration: float) -> void:
	speed = base_speed * (1.0 + multiplier)
	_boost_time_left = duration


func pickup_candy() -> void:
	candies += 1
	candies_changed.emit(candies)


func _take_hit() -> void:
	_hit_cd_left = hit_cooldown

	var drop_count: int = mini(drop_per_hit, candies)
	for i in drop_count:
		_spawn_dropped_candy()
	candies = max(candies - drop_count, 0)
	candies_changed.emit(candies)

	_flash_hurt()

	if candies <= 0:
		_is_dead = true
		game_over.emit()


func _spawn_dropped_candy() -> void:
	var candy: Area2D = CANDY_SCENE.instantiate()
	var angle := randf() * TAU
	var dist := randf_range(45.0, 85.0)
	candy.position = global_position + Vector2(cos(angle), sin(angle)) * dist
	if candy.has_method("set_as_drop"):
		candy.set_as_drop()
	get_parent().add_child(candy)


func _flash_hurt() -> void:
	var tween := create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1.0, 0.3, 0.3, 1.0), 0.1)
	tween.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.3)
