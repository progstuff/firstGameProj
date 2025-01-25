extends CharacterBody2D

@onready var anim_state = $AnimationTree.get("parameters/playback")
@onready var anim_tree = $AnimationTree

enum states {MOVE, IDLE, DEAD}
var current_state = states.MOVE

var input_movement = Vector2.ZERO
var walkSpeed = 70
var shiftSpeed = walkSpeed*6
var currentPlayerSpeed = walkSpeed

func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING
	$SwordScene.visible = true
	
func _physics_process(delta: float) -> void:
	
	match current_state:
		states.MOVE:
			move()

func move() -> void:
	
	input_movement = Input.get_vector("left", "right", "up", "down")
	
	if input_movement != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_movement)
		anim_tree.set("parameters/Walk/blend_position", input_movement)
		anim_state.travel("Walk")
		
		if(Input.is_action_just_pressed("shift")):
			currentPlayerSpeed = shiftSpeed
			$CollisionShape2D.disabled = true
			$Timer.start()
		
		velocity = input_movement  * currentPlayerSpeed
	
	if input_movement == Vector2.ZERO:
		anim_state.travel("Idle")
		velocity = Vector2.ZERO
	
	move_and_slide()


func _on_timer_timeout() -> void:
	currentPlayerSpeed = walkSpeed
	$CollisionShape2D.disabled = false
	

	
	
