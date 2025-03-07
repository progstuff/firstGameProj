extends CharacterBody2D
class_name Player

@export var level = 1
@export var nextLevelExp = 20
@export var curExp = 0
@export var curHp = 100
@export var maxHp = 100

@export var score = 0
@onready var anim_state = $AnimationTree.get("parameters/playback")
@onready var anim_tree = $AnimationTree

var hpBarShift = Vector2.ZERO

var LEVEL_MULTIPLIER = 1.2

enum states {MOVE, IDLE, DEAD, DODGE}
var current_state = states.MOVE

var input_movement = Vector2.ZERO
var walkSpeed = 70
var shiftSpeed = walkSpeed*12
var currentPlayerSpeed = walkSpeed

func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING
	var interface = get_parent().get_parent().get_parent().get_node("Interface")
	interface.levelUp(level, nextLevelExp)
	
	$HpBar.value = curHp
	$HpBar.max_value = maxHp
	var hpBarSize = $HpBar.get_rect().size
	var spriteSize = $Sprite2D.get_rect().size * $Sprite2D.scale
	hpBarShift.y = spriteSize.y/2 + hpBarSize.y
	hpBarShift.x = -hpBarSize.x/2
	$HpBar.position = hpBarShift
	
func _physics_process(_delta: float) -> void:
	
	if(Input.is_action_just_pressed("ZoomIn")):
		$Camera2D.zoom = $Camera2D.zoom*1.1
	
	if(Input.is_action_just_pressed("ZoomOut")):
		$Camera2D.zoom = $Camera2D.zoom/1.1
		
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
		if(current_state != states.DODGE):
			var damage = area.get_parent().getDamage()
			curHp -= damage
			if(curHp < 0):
				curHp = 0
			$HpBar.value = curHp
			
		
	elif(area.name == "item"):
		score +=1 
		area.get_parent().queue_free()
		get_parent().get_parent().get_parent().get_node("Interface").collectCoin()
		collectExp()

func collectExp():
	var interface = get_parent().get_parent().get_parent().get_node("Interface")
	
	curExp += 1
	if(curExp >= nextLevelExp):
		level+=1
		curExp = 0
		nextLevelExp = round(nextLevelExp*LEVEL_MULTIPLIER)
		
		interface.levelUp(level, nextLevelExp)
		interface.showSkillsLvlUpForPlayer()
	else:
		interface.changeExpereance(curExp)
