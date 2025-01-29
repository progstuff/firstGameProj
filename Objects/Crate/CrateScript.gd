extends StaticBody2D
@export var live = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = "crate"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
	if(area.name == "sword"):
		$AnimationPlayer.play("destroy")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "destroy"):
		live = 0
		visible = false
