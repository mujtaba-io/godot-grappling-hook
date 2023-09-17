
# Author: Mujtaba muhammadmujtaba150@gmail.com
# GitHub: github.com/mujtaba-io/

extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var rope : Line2D
var rope_head : Node2D

var is_triggered : bool = false
var is_grippling : bool = false

var source : Vector2
var destination : Vector2

func trigger_grippling() -> void:
	is_triggered = true

func _ready():
	rope = $Rope
	rope_head = $Rope/Head


func _process(delta):
	if is_triggered:
		is_triggered = false
		is_grippling = true
		destination = get_global_mouse_position() * global_transform
		source = self.position
		# If attempted to gripple below horizontal, do nothing
		if destination.dot(Vector2.UP) < 0:
			is_triggered = false
			is_grippling = false
			rope.points[0] = Vector2.ZERO
			rope.points[1] = Vector2.ZERO
			rope.position = Vector2.ZERO
	
	if is_grippling:
		if not rope.points[1].distance_to(destination) < 1:
			rope.points[1] = lerp(rope.points[1], destination, 0.3)
		else:
			rope.points[0] = lerp(rope.points[0], destination, 0.2)
			self.position = rope.points[0] + source
		if rope.points[0].distance_to(destination) < 1:
			is_grippling = false
			rope.points[0] = Vector2.ZERO
			rope.points[1] = Vector2.ZERO
			rope.position = self.position
	rope.position = -rope.points[0]
	rope_head.position = rope.points[1]


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("shift_key"):
		trigger_grippling()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
