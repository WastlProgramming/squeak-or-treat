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


func _ready() -> void:
	add_to_group("candy")
	$Sprite2D.texture = load(CANDY_TEXTURES.pick_random())
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	if body.has_method("apply_speed_boost"):
		body.apply_speed_boost(BOOST_MULTIPLIER, BOOST_DURATION)
	queue_free()
