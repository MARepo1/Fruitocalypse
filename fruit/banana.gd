extends RigidBody3D

func fruit(shooter_name):
	var fruit_type = "Banana"
	SetPlayers.set_fruit.emit(shooter_name, fruit_type)
	queue_free()
