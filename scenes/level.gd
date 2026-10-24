extends Node2D

@onready var timer: Timer = $Timer
var time_label: Label
var elapsed: float = 0.0
var game_started: bool = false


const MONSTER_SCENE: PackedScene = preload("res://scenes/monster.tscn")
const CANDY_SCENE: PackedScene = preload("res://scenes/candy.tscn")
const VARIANTS: Array[StringName] = [
	&"ghost", &"zombie_boy", &"zombie_girl", &"vampire", &"witch",
	&"skeleton", &"mummy", &"pumpkin", &"werewolf", &"demon"
]
const CANDY_SPAWN_INTERVAL: float = 2.0
const SPAWN_MIN := Vector2(80, 60)
const SPAWN_MAX := Vector2(1200, 660)

var _candy_timer: Timer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	var ui := CanvasLayer.new()
	add_child(ui)

	time_label = Label.new()
	time_label.position = Vector2(20, 20)
	time_label.add_theme_font_size_override("font_size", 32)
	time_label.add_theme_color_override("font_color", Color.ORANGE)
	ui.add_child(time_label)

	timer.one_shot = true
	timer.timeout.connect(_on_game_start)
	timer.start(10.0)


func spawn_monster(pos: Vector2) -> void:
	var monster: CharacterBody2D = MONSTER_SCENE.instantiate()
	monster.position = pos
	add_child(monster)
	var sprite: AnimatedSprite2D = monster.get_node("AnimatedSprite2D")
	sprite.play(VARIANTS.pick_random())


func spawn_candy() -> void:
	var candy: Area2D = CANDY_SCENE.instantiate()
	candy.position = Vector2(
		randf_range(SPAWN_MIN.x, SPAWN_MAX.x),
		randf_range(SPAWN_MIN.y, SPAWN_MAX.y)
	)
	add_child(candy)


func _process(delta: float) -> void:
	if game_started:
		elapsed += delta
		var minutes := int(elapsed) / 60
		var seconds := int(elapsed) % 60
		time_label.text = "%02d:%02d" % [minutes, seconds]
	else:
		time_label.text = str(ceili(timer.time_left))


func _on_game_start() -> void:
	game_started = true
	elapsed = 0.0
	get_tree().paused = false
	for i in 5:
		spawn_monster(Vector2(randf_range(100, 1100), randf_range(100, 600)))

	_candy_timer = Timer.new()
	_candy_timer.wait_time = CANDY_SPAWN_INTERVAL
	_candy_timer.autostart = true
	_candy_timer.timeout.connect(spawn_candy)
	add_child(_candy_timer)
	spawn_candy()


func _on_timer_timeout() -> void:
	pass
