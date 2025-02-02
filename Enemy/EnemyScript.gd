extends CharacterBody2D

class_name EnemyClass

@onready var player = $"../Player"
var coinScene = load("res://Items/Coin/CoinScene.tscn")

@export var typeName = "enemy"
@export var input_movement = Vector2.ZERO
@export var rageSpeed = 1
@export var walkSpeed = 25
@export var live = 1
@onready var anim_state = $AnimationTree.get("parameters/playback")
@onready var anim_tree = $AnimationTree

enum states {MOVE, RAGE, IDLE, DEAD}
var currentState = states.MOVE

var patruleDistance = 200
var centerPoint = Vector2.ZERO

func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING
	
func _physics_process(_delta: float) -> void:
	
	match currentState:
		states.MOVE:
			move(_delta)
		states.RAGE:
			move(_delta)
		states.DEAD:
			dead()
			
func dead() -> void:
	anim_state.travel("Dead")
	
func move(delta: float) -> void:
	
	if(live > 0):
		
		changePosition(delta)
		
		if input_movement != Vector2.ZERO:
			anim_tree.set("parameters/Idle/blend_position", input_movement)
			anim_tree.set("parameters/Walk/blend_position", input_movement)
			anim_tree.set("parameters/Dead/blend_position", input_movement)
			anim_state.travel("Walk")
			
		if input_movement == Vector2.ZERO:
			anim_state.travel("Idle")
		
		move_and_slide()

func changePosition(delta: float):
	var playerPosition = player.get_child(0).position
	var direction = input_movement
	
	if(direction == Vector2.ZERO):
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	
	if(live <= 0):
		direction = Vector2.ZERO
	else:
		var distance = (position - playerPosition).length()

		if(distance <= 100):
			currentState = states.RAGE
		elif(distance >= 150):
			if(currentState == states.RAGE):
				currentState = states.MOVE
				centerPoint = position
			elif(currentState == states.MOVE):
				if(centerPoint == Vector2.ZERO):
					centerPoint = position
					direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	
	if(currentState == states.RAGE):
		direction = position.direction_to(playerPosition)
		direction = direction.normalized()
		input_movement = direction
		position = position + direction*rageSpeed*delta
	elif(currentState == states.MOVE):
		var distanceFromCenter = (position - centerPoint).length()
		
		if(distanceFromCenter > patruleDistance):
			direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
			centerPoint = position
			
		direction = direction.normalized()
		input_movement = direction
		position = position + direction*walkSpeed*delta
		
func erase() -> void:
	var coin = coinScene.instantiate()
	coin.position = position
	get_parent().add_child(coin)
	queue_free()

func _on_enemy_area_entered(area: Area2D) -> void:
	if(area.name == "sword"):
		$Sprite2D.visible = false
		$DeathSprites.visible = true
		currentState = states.DEAD


func _on_raged(enemyPosition: Vector2) -> void:
	if(currentState == states.MOVE):
		var distance = (position - enemyPosition).length()
		if(distance <= 300):
			currentState = states.RAGE
