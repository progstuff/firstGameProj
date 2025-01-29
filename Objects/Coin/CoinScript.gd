extends StaticBody2D

@export var collected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("rotation")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.name == "player"):
		visible = false
		collected = true
