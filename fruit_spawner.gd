extends Marker3D

@export var apple_scene = preload("res://Fruit/apple.tscn")
@export var banana_scene = preload("res://Fruit/banana.tscn")
@export var orange_scene = preload("res://Fruit/orange.tscn")
@export var pineapple_scene = preload("res://Fruit/pineapple.tscn")
@export var watermelon_scene = preload("res://Fruit/watermelon.tscn")

var num_of_fruit = 1
var seconds = 5

var rand_x
var rand_y
var rand_z

@onready var timer = $FruitTimer

func _ready():
	timer.wait_time = seconds
	timer.start()

	
func spawn_apple():
	await(get_tree().create_timer(0.1).timeout)
	var apple = apple_scene.instantiate()
	add_child(apple)
	rand_x = randf_range(-20,20)
	rand_y = randf_range(-20,20)
	rand_z = randf_range(-20,20)
	apple.global_position = Vector3(rand_x,rand_y,rand_z)

func spawn_banana():
	await(get_tree().create_timer(0.1).timeout)
	var banana = banana_scene.instantiate()
	add_child(banana)
	rand_x = randf_range(-20,20)
	rand_y = randf_range(-20,20)
	rand_z = randf_range(-20,20)
	banana.global_position = Vector3(rand_x,rand_y,rand_z)
	
func spawn_orange():
	await(get_tree().create_timer(0.1).timeout)
	var orange = orange_scene.instantiate()
	add_child(orange)
	rand_x = randf_range(-20,20)
	rand_y = randf_range(-20,20)
	rand_z = randf_range(-20,20)
	orange.global_position = Vector3(rand_x,rand_y,rand_z)
	
func spawn_pineapple():
	await(get_tree().create_timer(0.1).timeout)
	var pineapple = pineapple_scene.instantiate()
	add_child(pineapple)
	rand_x = randf_range(-20,20)
	rand_y = randf_range(-20,20)
	rand_z = randf_range(-20,20)
	pineapple.global_position = Vector3(rand_x,rand_y,rand_z)
	
func spawn_watermelon():
	await(get_tree().create_timer(0.1).timeout)
	var watermelon = watermelon_scene.instantiate()
	add_child(watermelon)
	rand_x = randf_range(-20,20)
	rand_y = randf_range(-20,20)
	rand_z = randf_range(-20,20)
	watermelon.global_position = Vector3(rand_x,rand_y,rand_z)
	
	
func _on_fruit_timer_timeout() -> void:

	spawn_apple()
	spawn_orange()
	spawn_banana()
	spawn_pineapple()
	spawn_watermelon()

		 
