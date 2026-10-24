extends Node2D                    
@onready var timer: Timer = $Timer
var time_label: Label


const MONSTER_SCENE: PackedScene = preload("res://scenes/monster.tscn")                                                                                                                     
const VARIANTS: Array[StringName] = [
	&"ghost", &"zombie_boy", &"zombie_girl", &"vampire", &"witch",                                                                                                                        
	&"skeleton", &"mummy", &"pumpkin", &"werewolf", &"demon"                                                                                                                              
  ]                                                                                                                                                                                           

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


func _process(delta: float) -> void:
	time_label.text = str(ceili(timer.time_left))

func _on_game_start() -> void:
	time_label.text = "Game startet"
	get_tree().paused = false
	for i in 5:
		spawn_monster(Vector2(randf_range(100, 1100), randf_range(100, 600)))

func _on_timer_timeout() -> void:
	print("Vorbei")
	
