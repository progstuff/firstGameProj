extends Node2D
var enemyScene = load("res://Enemy/EnemyScene.tscn")
var playerScene = load("res://Player/PlayerScene.tscn")
var mapScene = load("res://Map/MapScene.tscn")
var crateScene = load("res://Objects/Crate/CrateScene.tscn")

var mobsCnt = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if($Player.get_child_count() == 0):
		return
		
	var player = $Player.get_child(0)
	var playerPosition = player.get_node("CharacterBody2D").position
					
	if($Map.get_child_count() == 0):
		return
		
	$Map.get_child(0).playerCoords = playerPosition
	
func _on_main_menu_start_game() -> void:
	
	var player = playerScene.instantiate()
	var screen_size = get_viewport().get_visible_rect().size
	var startPlayerPosition = screen_size/2
	player.get_node("CharacterBody2D").position = startPlayerPosition
	$Player.add_child(player)
	
	var landscape = mapScene.instantiate()
	landscape.playerCoords = startPlayerPosition
	landscape.mapCenter = startPlayerPosition
	landscape.playState = true
	$Map.add_child(landscape)
	
	generateCrates()
	
	$MobSpawnTimer.start()

func generateCrates() -> void:
	var rand = RandomNumberGenerator.new()
	for i in range(1, 3):
		var crate = crateScene.instantiate()
		var x = rand.randi_range(0, 1000);
		var y = rand.randi_range(-300, 300);
		crate.position = Vector2(x, y)
		add_child(crate)
		
func _on_mob_spawn_timer_timeout() -> void:
	if($Player.get_child_count() == 0):
		return
	
	if(mobsCnt <= 50):
		var player = $Player.get_child(0)
		var playerPosition = player.get_node("CharacterBody2D").position
		
		var rand = RandomNumberGenerator.new()
		var screen_size = get_viewport().get_visible_rect().size
		
		var enemiesCount = rand.randi_range(30, 50)
		for i in range(0,enemiesCount):
			var enemyObject = enemyScene.instantiate()
			
			rand.randomize()
			var x = rand.randf_range(0, screen_size.x) + playerPosition.x - screen_size.x/2
			rand.randomize()
			var y = rand.randf_range(0, screen_size.y) + playerPosition.y - screen_size.y/2
			var randomPos = Vector2(x,y)
			
			enemyObject.get_node("CharacterBody2D").position = randomPos
			enemyObject.get_node("CharacterBody2D").speed = rand.randi_range(50, 160)
			add_child(enemyObject)


func _on_debug_timer_timeout() -> void:
	if($Player.get_child_count() == 0):
		return
		
	var player = $Player.get_child(0)
	var playerPosition = player.get_node("CharacterBody2D").position
	
	print(mobsCnt)

func _on_child_entered_tree(node: Node) -> void:
	if(node.has_node("CharacterBody2D")):
		var el = node.get_node("CharacterBody2D")
		if(el.has_node("enemy")):
			mobsCnt += 1

func _on_child_exiting_tree(node: Node) -> void:
	if(node.has_node("CharacterBody2D")):
		var el = node.get_node("CharacterBody2D")
		if(el.has_node("enemy")):
			mobsCnt -= 1
