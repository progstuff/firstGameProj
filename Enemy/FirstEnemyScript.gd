extends EnemyClass

var crateScene = load("res://Objects/Crate/CrateScene.tscn")

func erase() -> void:
	var crate = crateScene.instantiate()
	crate.position = position
	get_parent().add_child(crate)
	queue_free()
