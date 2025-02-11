extends Node2D

var firstEnemyTypeScene = load("res://Enemy/EnemyFirstType/EnemyFirstTypeScene.tscn")
var secondEnemyTypeScene = load("res://Enemy/EnemySecondType/EnemySecondTypeScene.tscn")
var enemiesTypes = [firstEnemyTypeScene, secondEnemyTypeScene]
var playerScene = load("res://Player/PlayerOneType/PlayerOneTypeScene.tscn")
var mapScene = load("res://Map/MapScene.tscn")
var crateScene = load("res://InteracteObjects/Crate/CrateScene.tscn")

var mobsCnt = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if($GameScene/Player.get_child_count() == 0):
		return
		
	var player = $GameScene/Player.get_child(0)
	
	if player.curHp <= 0:
		get_tree().paused = true
		player.visible = false
		
		$MainMenu.layer = 2
		$MainMenu.showGameOverMenu()
		
	var playerPosition = player.position
					
	if($GameScene/Map.get_child_count() == 0):
		return
		
	$GameScene/Map.get_child(0).playerCoords = playerPosition

func clearScene() -> void:
	$GameScene/MobSpawnTimer.stop()
	
	for n in $GameScene/Map.get_children():
		$GameScene/Map.remove_child(n)
		n.queue_free()
		
	for n in $GameScene/Coins.get_children():
		$GameScene/Coins.remove_child(n)
		n.queue_free()
		
	for n in $GameScene/Enemies.get_children():
		$GameScene/Enemies.remove_child(n)
		n.queue_free()
	
	for n in $GameScene/Items.get_children():
		$GameScene/Items.remove_child(n)
		n.queue_free()
	
	for n in $GameScene/Player.get_children():
		$GameScene/Player.remove_child(n)
		n.queue_free()
		
	$Interface.visible = false
	
func _on_main_menu_start_game() -> void:
	
	$Interface.init()
	
	var player = playerScene.instantiate()
	var screen_size = get_viewport().get_visible_rect().size
	var startPlayerPosition = screen_size/2
	player.position = startPlayerPosition
	$GameScene/Player.add_child(player)
	
	var landscape = mapScene.instantiate()
	landscape.playerCoords = startPlayerPosition
	landscape.mapCenter = startPlayerPosition
	landscape.playState = true
	$GameScene/Map.add_child(landscape)
	
	generateCrates()
	
	$GameScene/MobSpawnTimer.start()

func generateCrates() -> void:
	for i in range(1, 3):
		var crate = crateScene.instantiate()
		var x = randi_range(0, 1000);
		var y = randi_range(-300, 300);
		crate.position = Vector2(x, y)
		$GameScene/Items.add_child(crate)
		
func _on_mob_spawn_timer_timeout() -> void:
	if($GameScene/Player.get_child_count() == 0):
		return
	
	if(mobsCnt <= 50):
		var player = $GameScene/Player.get_child(0)
		var playerPosition = player.position
		
		var enemiesCount = randi_range(10, 20)
		for i in range(0,enemiesCount):
			var enemyTypeInd = randi_range(0, 1)
			var enemyObject = enemiesTypes[enemyTypeInd].instantiate()
			
			
			var degree = randf_range(0, 2*PI)
			var distance = randf_range(500, 900)
			var x = distance * cos(degree)
			var y = distance * sin(degree)
			var randomPos = Vector2(x,y) + playerPosition
			
			enemyObject.position = randomPos
			$GameScene/Enemies.add_child(enemyObject)

func _on_debug_timer_timeout() -> void:
	if($GameScene/Player.get_child_count() == 0):
		return
		
	var player = $GameScene/Player.get_child(0)
	var playerPosition = player.position
	
	print(mobsCnt)

func _on_game_scene_child_entered_tree(node: Node) -> void:
	if(node.has_node("enemy")):
		mobsCnt += 1

func _on_game_scene_child_exiting_tree(node: Node) -> void:
	if(node.has_node("enemy")):
		mobsCnt -= 1

func _on_main_menu_restart_game() -> void:
	clearScene()
	_on_main_menu_start_game()
	$MainMenu.layer = 1
	get_tree().paused = false
