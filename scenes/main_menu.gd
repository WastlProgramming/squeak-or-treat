extends Control


const GROUND_Y: float = 540.0
const WALK_RIGHT_X: float = 1320.0
const WALK_LEFT_X: float = -120.0


func _ready() -> void:
	$Buttons/StartButton.pressed.connect(_on_start)
	$Buttons/QuitButton.pressed.connect(_on_quit)
	await get_tree().process_frame
	_animate_title()
	_animate_zombie_cycle()
	_animate_werewolf()
	_animate_ghost()
	_animate_bats()
	_animate_trees()
	_animate_moon()


func _on_start() -> void:
	print("[MainMenu] Start pressed")
	get_tree().change_scene_to_file("res://scenes/player_choice.tscn")


func _on_quit() -> void:
	print("[MainMenu] Quit pressed")
	get_tree().quit()


func _animate_title() -> void:
	var title: Label = $Title
	title.pivot_offset = title.size / 2

	var pulse := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pulse.tween_property(title, "scale", Vector2(1.08, 1.08), 1.2)
	pulse.tween_property(title, "scale", Vector2(1.0, 1.0), 1.2)

	var start_y := title.position.y
	var bob := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	bob.tween_property(title, "position:y", start_y - 10, 1.8)
	bob.tween_property(title, "position:y", start_y, 1.8)

	var glow := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	glow.tween_property(title, "modulate", Color(1.0, 0.7, 0.4, 1.0), 1.5)
	glow.tween_property(title, "modulate", Color(1.0, 1.0, 1.0, 1.0), 1.5)


func _animate_zombie_cycle() -> void:
	var zombie: TextureRect = $GraveZombieArea/Zombie
	while is_inside_tree():
		zombie.position = Vector2(180.0, 636.0)
		zombie.rotation = 0.0
		zombie.modulate = Color(0.9, 0.95, 0.9, 1.0)

		var claw := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		claw.tween_property(zombie, "position:y", 600.0, 1.0)
		await claw.finished
		if not is_inside_tree(): return

		var shake := create_tween().set_loops(3)
		shake.tween_property(zombie, "position:x", 184.0, 0.08)
		shake.tween_property(zombie, "position:x", 176.0, 0.08)
		await shake.finished
		if not is_inside_tree(): return
		zombie.position.x = 180.0

		var rise := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		rise.tween_property(zombie, "position:y", GROUND_Y, 2.0)
		await rise.finished
		if not is_inside_tree(): return

		var walk := create_tween()
		walk.tween_property(zombie, "position:x", WALK_RIGHT_X, 18.0)

		var bob := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		bob.tween_property(zombie, "position:y", GROUND_Y - 5.0, 0.32)
		bob.tween_property(zombie, "position:y", GROUND_Y, 0.32)

		var sway := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		sway.tween_property(zombie, "rotation", 0.1, 0.32)
		sway.tween_property(zombie, "rotation", -0.1, 0.32)

		await walk.finished
		bob.kill()
		sway.kill()
		if not is_inside_tree(): return

		zombie.rotation = 0.0
		var fade := create_tween()
		fade.tween_property(zombie, "modulate:a", 0.0, 0.4)
		await fade.finished

		await get_tree().create_timer(3.0).timeout


func _animate_werewolf() -> void:
	var wolf: TextureRect = $Monsters/Werewolf
	wolf.scale.x = -1.0
	_walk_with_dynamics(wolf, 1320.0, -120.0, 16.0, 0.28, 0.12, 6.0)


func _walk_with_dynamics(sprite: TextureRect, from_x: float, to_x: float, duration: float, step_time: float, sway_amount: float, bob_amount: float) -> void:
	sprite.position.x = from_x
	var base_y := sprite.position.y

	var walk := create_tween().set_loops()
	walk.tween_property(sprite, "position:x", to_x, duration)
	walk.tween_callback(func(): sprite.position.x = from_x)

	var bob := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	bob.tween_property(sprite, "position:y", base_y - bob_amount, step_time)
	bob.tween_property(sprite, "position:y", base_y, step_time)

	var sway := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	sway.tween_property(sprite, "rotation", sway_amount, step_time)
	sway.tween_property(sprite, "rotation", -sway_amount, step_time)


func _animate_ghost() -> void:
	var ghost: TextureRect = $Monsters/Ghost
	var base_y := ghost.position.y

	var drift := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	drift.tween_property(ghost, "position:x", 1050.0, 15.0)
	drift.tween_property(ghost, "position:x", 100.0, 15.0)

	var float_y := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	float_y.tween_property(ghost, "position:y", base_y - 30.0, 2.4)
	float_y.tween_property(ghost, "position:y", base_y + 30.0, 2.4)

	var breathe := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	breathe.tween_property(ghost, "scale", Vector2(1.08, 0.95), 1.6)
	breathe.tween_property(ghost, "scale", Vector2(0.95, 1.08), 1.6)

	var flicker := create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	flicker.tween_property(ghost, "modulate:a", 0.45, 1.8)
	flicker.tween_property(ghost, "modulate:a", 0.75, 1.8)


func _animate_bats() -> void:
	for bat: TextureRect in $Bats.get_children():
		var base_y := bat.position.y
		var duration := randf_range(9.0, 15.0)

		var fly := create_tween().set_loops()
		fly.tween_property(bat, "position:x", 1360.0, duration)
		fly.tween_callback(func(): bat.position.x = -80.0)

		var wobble_amount := randf_range(14.0, 28.0)
		var wobble_time := randf_range(0.35, 0.6)
		var wobble := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		wobble.tween_property(bat, "position:y", base_y - wobble_amount, wobble_time)
		wobble.tween_property(bat, "position:y", base_y + wobble_amount, wobble_time)

		var flap := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		flap.tween_property(bat, "scale", Vector2(1.0, 0.6), 0.12)
		flap.tween_property(bat, "scale", Vector2(1.0, 1.0), 0.12)

		var tilt := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tilt.tween_property(bat, "rotation", 0.15, wobble_time)
		tilt.tween_property(bat, "rotation", -0.15, wobble_time)


func _animate_trees() -> void:
	var i := 0
	for tree: TextureRect in $Trees.get_children():
		var sway_amount := 0.015 + 0.005 * (i % 3)
		var sway_time := 2.5 + 0.3 * i
		var sway := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		sway.tween_property(tree, "rotation", sway_amount, sway_time)
		sway.tween_property(tree, "rotation", -sway_amount, sway_time)
		i += 1


func _animate_moon() -> void:
	var moon: TextureRect = $Moon
	var glow: ColorRect = $MoonGlow

	var pulse := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pulse.tween_property(moon, "scale", Vector2(1.03, 1.03), 3.0)
	pulse.tween_property(moon, "scale", Vector2(1.0, 1.0), 3.0)

	var glow_pulse := create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	glow_pulse.tween_property(glow, "modulate:a", 1.5, 3.0)
	glow_pulse.tween_property(glow, "modulate:a", 0.6, 3.0)
