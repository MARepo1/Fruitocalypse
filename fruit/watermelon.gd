extends RigidBody3D

func fruit(shooter_name):
	var fruit_type = "watermelon"
	SetPlayers.set_fruit.emit(shooter_name, fruit_type)
	queue_free()
