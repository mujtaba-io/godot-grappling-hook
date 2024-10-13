extends CharacterBody2D


var is_grappling: bool = false

func _process(delta):
	# Just move the player left and right or top bottom (simple player motion)

	# Add damping to the player's velocity
	velocity = velocity.lerp(Vector2.ZERO, 0.02)

	if not is_grappling: # Only move player if grappling is not active
		if Input.is_action_pressed("ui_right"):
			velocity.x += 100 * delta  # Move right
		elif Input.is_action_pressed("ui_left"):
			velocity.x -= 100 * delta  # Move left
		if Input.is_action_pressed("ui_down"):
			velocity.y += 100 * delta  # Move down
		elif Input.is_action_pressed("ui_up"):
			velocity.y -= 100 * delta  # Move up
		
		# Add gravity to the player's velocity
		velocity.y += 1000 * delta
	
	# Move the player
	move_and_slide()

	# if player jumps, call attach_player function on all grappling hook systems
	# so whichever will be in range will attach the player
	if Input.is_action_just_pressed("ui_home"):
		for grappling_hook_system in get_tree().get_nodes_in_group("grappling-hook-system"):
			var success = grappling_hook_system.attach_player(self)
			if success == 0:
				is_grappling = true
				break	
	elif Input.is_action_just_released("ui_home"):
		for grappling_hook_system in get_tree().get_nodes_in_group("grappling-hook-system"):
			var success = grappling_hook_system.detach_player(self)
			if success == 0:
				is_grappling = false
				break
	
	global_rotation = 0 # dont rotate as grappling hook swings
