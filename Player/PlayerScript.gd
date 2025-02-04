extends CharacterBody2D
class_name Player

@export var level = 1
@export var nextLevelExp = 10
@export var curExp = 0

@export var score = 0
@onready var anim_state = $AnimationTree.get("parameters/playback")
@onready var anim_tree = $AnimationTree

var LEVEL_MULTIPLIER = 1.2

enum states {MOVE, IDLE, DEAD, DODGE}
var current_state = states.MOVE

var input_movement = Vector2.ZERO
var walkSpeed = 70
var shiftSpeed = walkSpeed*6
var currentPlayerSpeed = walkSpeed

func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING
	get_parent().get_parent().get_node("Interface").levelUp(level, nextLevelExp)
	
func _physics_process(_delta: float) -> void:
	move()
			
func move() -> void:
	
	input_movement = Input.get_vector("left", "right", "up", "down")
	
	if input_movement != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_movement)
		anim_tree.set("parameters/Walk/blend_position", input_movement)
		anim_state.travel("Walk")
		
		if(Input.is_action_just_pressed("shift")):
			current_state = states.DODGE
			currentPlayerSpeed = shiftSpeed
			$CollisionShape2D.disabled = true
			$Timer.start()
		
		velocity = input_movement  * currentPlayerSpeed
	
	if input_movement == Vector2.ZERO:
		current_state = states.IDLE
		anim_state.travel("Idle")
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_timer_timeout() -> void:
	current_state = states.MOVE
	currentPlayerSpeed = walkSpeed
	$CollisionShape2D.disabled = false

func _on_player_area_entered(area: Area2D) -> void:
	if(area.name == "enemy"):
		pass
	elif(area.name == "item"):
		score +=1 
		area.get_parent().queue_free()
		get_parent().get_parent().get_node("Interface").collectCoin()
		collectExp()

func collectExp():
	curExp += 1
	if(curExp >= nextLevelExp):
		level+=1
		curExp = 0
		nextLevelExp = round(nextLevelExp*LEVEL_MULTIPLIER)
		get_parent().get_parent().get_node("Interface").levelUp(level, nextLevelExp)
	else:
		get_parent().get_parent().get_node("Interface").changeExpereance(curExp)
