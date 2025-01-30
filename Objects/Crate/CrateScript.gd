extends StaticBody2D

var coinScene = load("res://Objects/Coin/CoinScene.tscn")
@export var live = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = "crate"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
	if(area.name == "sword"):
		$AnimationPlayer.play("destroy")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "destroy"):
		var coin = coinScene.instantiate()
		coin.position = position
		get_parent().add_child(coin)
		queue_free()
