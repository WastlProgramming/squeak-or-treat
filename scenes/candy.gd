extends Area2D

const CANDY_TEXTURES: Array[String] = [
	"res://assets/candy/bonbon_wrapped.svg",
	"res://assets/candy/candy_corn.svg",
	"res://assets/candy/candy_skull.svg",
	"res://assets/candy/caramel_apple.svg",
	"res://assets/candy/chocolate_bar.svg",
	"res://assets/candy/gummy_worm.svg",
	"res://assets/candy/jelly_bean.svg",
	"res://assets/candy/lollipop_red.svg",
	"res://assets/candy/lollipop_swirl.svg",
]

const BOOST_MULTIPLIER: float = 0.20
const BOOST_DURATION: float = 5.0
const DROP_LIFETIME: float = 5.0

var is_drop: bool = false


func _ready() -> void:
	$Sprite2D.texture = load(CANDY_TEXTURES.pick_random())
	body_entered.connect(_on_body_entered)

	if is_drop:
		monitoring = false
		_play_drop_animation()
	else:
		add_to_group("candy")


func set_as_drop() -> void:
	is_drop = true
	monitoring = false


func _play_drop_animation() -> void:
	rotation = randf_range(-PI, PI)

	var pop := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	pop.tween_property(self, "scale", scale, 0.35).from(scale * 0.2)

	var spin := create_tween()
	spin.tween_property(self, "rotation", rotation + randf_range(-1.5, 1.5), DROP_LIFETIME)

	var fade := create_tween()
	fade.tween_interval(DROP_LIFETIME - 1.5)
	fade.tween_property(self, "modulate:a", 0.0, 1.5)
	fade.tween_callback(queue_free)


func _on_body_entered(body: Node) -> void:
	if is_drop:
		return
	if not body.is_in_group("player"):
		return
	if body.has_method("apply_speed_boost"):
		body.apply_speed_boost(BOOST_MULTIPLIER, BOOST_DURATION)
	if body.has_method("pickup_candy"):
		body.pickup_candy()
	queue_free()
