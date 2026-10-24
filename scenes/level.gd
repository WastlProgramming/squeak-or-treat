extends Node2D

@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = $Player

var ui: CanvasLayer
var time_label: Label
var candies_label: Label
var elapsed: float = 0.0
var game_started: bool = false
var is_game_over: bool = false


const MONSTER_SCENE: PackedScene = preload("res://scenes/monster.tscn")
const CANDY_SCENE: PackedScene = preload("res://scenes/candy.tscn")
const BUCKET_TEXTURE: Texture2D = preload("res://assets/items/pumpkin_bucket.svg")
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
	ui = CanvasLayer.new()
	add_child(ui)

	time_label = Label.new()
	time_label.position = Vector2(20, 20)
	time_label.add_theme_font_size_override("font_size", 32)
	time_label.add_theme_color_override("font_color", Color.ORANGE)
	ui.add_child(time_label)

	var bucket_icon := TextureRect.new()
	bucket_icon.texture = BUCKET_TEXTURE
	bucket_icon.position = Vector2(1140, 12)
	bucket_icon.size = Vector2(56, 56)
	bucket_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bucket_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ui.add_child(bucket_icon)

	candies_label = Label.new()
	candies_label.text = "0"
	candies_label.position = Vector2(1200, 20)
	candies_label.add_theme_font_size_override("font_size", 36)
	candies_label.add_theme_color_override("font_color", Color.ORANGE)
	ui.add_child(candies_label)

	player.candies_changed.connect(_on_candies_changed)
	player.game_over.connect(_on_player_game_over)
	_on_candies_changed(player.candies)

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


func _on_candies_changed(count: int) -> void:
	candies_label.text = str(count)


func _on_player_game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	game_started = false
	get_tree().paused = true

	var over_label := Label.new()
	over_label.text = "GAME OVER"
	over_label.add_theme_font_size_override("font_size", 96)
	over_label.add_theme_color_override("font_color", Color(1.0, 0.2, 0.2, 1.0))
	over_label.position = Vector2(380, 300)
	ui.add_child(over_label)

	var score_label := Label.new()
	score_label.text = "Zeit: %02d:%02d" % [int(elapsed) / 60, int(elapsed) % 60]
	score_label.add_theme_font_size_override("font_size", 36)
	score_label.add_theme_color_override("font_color", Color.ORANGE)
	score_label.position = Vector2(520, 410)
	ui.add_child(score_label)

	await get_tree().create_timer(3.0, true, false, true).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
