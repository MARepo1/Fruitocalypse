extends CharacterBody3D

var sparks = preload("res://sparks.tscn")

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 10
var jump_speed = 5
var jump_count = 0
var max_jumps = 2
var mouse_sensitivity = 0.002
var life = 3
var damage_dealt

var rand_x
var rand_y
var rand_z
var min_height = 5.0

@onready var camera = $Camera3D
@onready var synchronizer = $MultiplayerSynchronizer

func _ready():
	synchronizer.set_multiplayer_authority(str(name).to_int())
	if synchronizer.is_multiplayer_authority():  # Only enable mouse control for the player with authority
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	camera.current = synchronizer.is_multiplayer_authority()
	randomize_spawn_position()
	
	
func randomize_spawn_position():
	rand_x = randf_range(-20,20)
	rand_y = randf_range(min_height, min_height + 20)
	rand_z = randf_range(-20,20)
	global_position = Vector3(rand_x,rand_y,rand_z)


	
@rpc("any_peer", "call_local")
func setup_multiplayer(player_id):
	set_multiplayer_authority(player_id)
	var is_player = player_id == get_multiplayer_authority()
	set_physics_process(is_player)
	set_process_unhandled_input(is_player)
	$Name.text = "P%s" % get_index()



func _physics_process(delta):
	if synchronizer.is_multiplayer_authority():
		var direction = Vector3.ZERO
		velocity.y += -gravity * delta
		var input = Input.get_vector("left", "right", "forward", "back")
		var movement_dir = transform.basis * Vector3(input.x, 0, input.y)

		velocity.x = movement_dir.x * speed
		velocity.z = movement_dir.z * speed
		
		move_and_slide()
		
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
			
		global_position += direction.normalized() * speed * delta
		synchronizer.position = global_position



func _input(event):
	if synchronizer.is_multiplayer_authority():
		# Toggle mouse mode with ESC key
		if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		
		# Handle mouse motion when in captured mode
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * mouse_sensitivity)
			synchronizer.y_rotation = rotation.y
			camera.rotate_x(-event.relative.y * mouse_sensitivity)
			
			# Clamp vertical rotation of the camera
			camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))
		if event.is_action_pressed("shoot"):
			shoot()

func shoot():
	var player_name = $Name.text
	var shooter_name = player_name
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create($Camera3D.global_position, $Camera3D.global_position + -$Camera3D.global_transform.basis.z * 100)
	var collision = space.intersect_ray(query)
	if collision:
		$CanvasLayer/Label.text = collision.collider.name
		var s = sparks.instantiate()
		get_tree().current_scene.add_child(s)
		s.position = collision.position
		s.emitting = true
		s.direction = collision.normal
		#damage_dealt = collision.collider.name create a list to manage the peerids if in list of ids then display
		if collision.collider.has_method("fruit"):
			collision.collider.fruit(shooter_name)
	else:
		$CanvasLayer/Label.text = ""
		
