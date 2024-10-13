extends Node2D

# Process to handle player input and swinging
func _process(delta):
	var player = $Player as RigidBody2D
	if Input.is_action_pressed("ui_right"):
		player.apply_central_impulse(player.global_transform.x * 100)  # Push right
	elif Input.is_action_pressed("ui_left"):
		player.apply_central_impulse(player.global_transform.x * -100)  # Push left
	
	# $Rope.points[0] = $Rope.to_local($StaticBody2D.global_position)
	$Rope.points[1] = player.global_position * $Rope.global_transform
