extends CanvasLayer
signal startGame
signal restartGame

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
				showPauseMenu()
			else:
				hideAll()
	else:
		showStartMenu()
	
func _on_new_game_button_button_down() -> void:
	hideAll()
	startGame.emit()
	isGameState = true

func _on_restart_button_button_down() -> void:
	hideAll()
	restartGame.emit()
	isGameState = true
	
func showStartMenu() -> void:
	$Control/Menus/StartMenuContainer.show()
	$Control/Menus/PauseLabel.hide()
	$Control/Menus/GameOverMenu.hide()
	
func showPauseMenu() -> void:
	$Control/Menus/StartMenuContainer.hide()
	$Control/Menus/PauseLabel.show()
	$Control/Menus/GameOverMenu.hide()
	
func showGameOverMenu() -> void:
	$Control/Menus/StartMenuContainer.hide()
	$Control/Menus/PauseLabel.hide()
	$Control/Menus/GameOverMenu.show()

func hideAll() -> void:
	$Control/Menus/StartMenuContainer.hide()
	$Control/Menus/PauseLabel.hide()
	$Control/Menus/GameOverMenu.hide()
