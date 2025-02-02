extends Node2D
var collisionsCnt = 0

func init() -> void:
	$sword/SwordDn.visible = false
	$sword/SwordUp.visible = false
	$sword/SwordUpShape.disabled = true
	$sword/SwordDnShape.disabled = true
	$sword/AttackTimer.start()

func _on_attack_timer_timeout() -> void:
	$sword/AnimationSword.play("sword")

func _on_draw() -> void:
	init()
