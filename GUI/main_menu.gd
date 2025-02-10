extends CanvasLayer
signal startGame

var isGameState = false
var isPaused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(isGameState):
		if(Input.is_action_just_pressed("Pause")):
			if(isPaused):
				if(get_tree().paused):
					isPaused = false
					get_tree().paused = false
			else:
				if(!get_tree().paused):
					isPaused = true
					get_tree().paused = true
					
			if(isPaused):
				$Control/PauseLabel.show()
			else:
				$Control/PauseLabel.hide()
	else:
		$Control/PauseLabel.hide()
		$Control/newGameButton.show()
	
func _on_new_game_button_button_down() -> void:
	$Control/newGameButton.hide()
	startGame.emit()
	isGameState = true
