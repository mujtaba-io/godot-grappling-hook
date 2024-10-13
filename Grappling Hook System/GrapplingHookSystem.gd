extends Node2D


@export var grapple_anchor: StaticBody2D
@export var player_anchor: RigidBody2D
@export var rope: Line2D

@export var max_radius: float = 512 # Only attach to things within this radius


func _ready():
	add_to_group("grappling-hook-system")
	rope.visible = false
	player_anchor.visible = false


# Process to handle player input and swinging
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		# if already moving fasdt, don't move faster
		if player_anchor.linear_velocity.length() < 400:
			player_anchor.apply_central_impulse(player_anchor.global_transform.x * 64)  # Push right
	elif Input.is_action_pressed("ui_left"):
		if player_anchor.linear_velocity.length() < 400:
			player_anchor.apply_central_impulse(player_anchor.global_transform.x * -64)  # Push left
	
	rope.points[0] = $GrappleAnchor.global_position * rope.global_transform
	rope.points[1] = player_anchor.global_position * rope.global_transform
	
	for child in player_anchor.get_children():
		if "position" in child:
			child.position = Vector2(0,0)




# API - use these functions to interact with grappling hook system


# Function to make the plaer a child of player_anchor and make
# all the things visible and working.

var player_original_parent: Node = null

func attach_player(player: Node2D) -> int:
	if self.global_position.distance_to(player.global_position) > max_radius or player_original_parent != null:
		return -1
	player_original_parent = player.get_parent()
	player_anchor.position = player.global_position # Set the player_anchor to the player's position
	player.reparent(player_anchor) # Make the player a child of player_anchor
	player.position = Vector2.ZERO

	rope.points[0] = $GrappleAnchor.global_position * rope.global_transform
	rope.points[1] = player_anchor.global_position * rope.global_transform

	rope.visible = true
	player_anchor.visible = true
	return 0



# Function to make the player no longer a child of player_anchor
# and make all the things invisible and not working.

func detach_player(player: Node2D) -> int:
	if player_original_parent == null:
		return -1
	player.reparent(player_original_parent)
	player.velocity = player_anchor.linear_velocity # So it continues its momentum
	player_original_parent = null
	rope.visible = false
	player_anchor.visible = false
	return 0
