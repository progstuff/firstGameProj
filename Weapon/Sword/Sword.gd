extends Node2D
var collisionsCnt = 0

func init() -> void:
	$Area2D/SwordDn.visible = false
	$Area2D/SwordUp.visible = false
	$Area2D/SwordUpShape.disabled = true
	$Area2D/SwordDnShape.disabled = true
	$Area2D/AttackTimer.start()

func _on_draw() -> void:
	init()

func _on_attack_timer_timeout() -> void:
	$Area2D/AnimationSword.play("sword")
