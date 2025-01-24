extends CharacterBody2D

@export var input_movement = Vector2.ZERO
@export var speed = 1
@onready var anim_state = $AnimationTree.get("parameters/playback")
@onready var anim_tree = $AnimationTree

enum states {MOVE, IDLE, DEAD}
var current_state = states.MOVE

func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING
	
func _physics_process(delta: float) -> void:
	
	match current_state:
		states.MOVE:
			move()

func move() -> void:
	
	if input_movement != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_movement)
		anim_tree.set("parameters/Walk/blend_position", input_movement)
		anim_state.travel("Walk")
	
	if input_movement == Vector2.ZERO:
		anim_state.travel("Idle")
	
	move_and_slide()
	
	
