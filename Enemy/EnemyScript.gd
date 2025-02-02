extends CharacterBody2D

class_name EnemyClass

@onready var player = $"../Player"
var coinScene = load("res://Items/Coin/CoinScene.tscn")

@export var typeName = "enemy"
@export var input_movement = Vector2.ZERO
@export var speed = 1
@export var live = 1
@onready var anim_state = $AnimationTree.get("parameters/playback")
@onready var anim_tree = $AnimationTree

enum states {MOVE, IDLE, DEAD}
var current_state = states.MOVE

func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING
	
func _physics_process(_delta: float) -> void:
	
	match current_state:
		states.MOVE:
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
	var enemyPosition = position
	var playerPosition = player.get_child(0).position
	var direction = enemyPosition.direction_to(playerPosition)
	
	if((enemyPosition - playerPosition).length() < 3):
		direction = Vector2.ZERO
	if(live <= 0):
		direction = Vector2.ZERO

	direction = direction.normalized()
	
	input_movement = direction
	position = position + direction*speed*delta
		
func erase() -> void:
	var coin = coinScene.instantiate()
	coin.position = position
	get_parent().add_child(coin)
	queue_free()

func _on_enemy_area_entered(area: Area2D) -> void:
	if(area.name == "sword"):
		$Sprite2D.visible = false
		$DeathSprites.visible = true
		current_state = states.DEAD
