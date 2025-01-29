extends Node2D
var enemyScene = load("res://Enemy/EnemyScene.tscn")
var playerScene = load("res://Player/PlayerScene.tscn")
var mapScene = load("res://Map/MapScene.tscn")
var crateScene = load("res://Objects/Crate/CrateScene.tscn")
var coinScene = load("res://Objects/Coin/CoinScene.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if($Player.get_child_count() == 0):
		return
		
	var player = $Player.get_child(0)
	var playerPosition = player.get_node("CharacterBody2D").position
	var enemies = $Mobs.get_children()
	for enemy in enemies:
		var enemyCharacter = enemy.get_node("CharacterBody2D")
		if(enemyCharacter.live == 0):
			var coin = coinScene.instantiate()
			coin.position = enemyCharacter.position
			$Coins.add_child(coin)
			
			$Mobs.remove_child(enemy)
			enemy.queue_free()
		else:
			var enemyPosition = enemyCharacter.position
			var direction = enemyPosition.direction_to(playerPosition)
			
			if((enemyPosition - playerPosition).length() < 3):
				direction = Vector2.ZERO
			if(enemyCharacter.live <= 0):
				direction = Vector2.ZERO

			direction = direction.normalized()
			
			enemyCharacter.input_movement = direction
			enemyCharacter.position = enemyCharacter.position + direction*delta*enemyCharacter.speed
	
	var objects = $Crates.get_children()
	for object in objects:
		if(object.live == 0):
			if(object.name == "crate"):
				var coin = coinScene.instantiate()
				coin.position = object.position
				$Coins.add_child(coin)
			$Crates.remove_child(object)
			object.queue_free()
			
	var coins = $Coins.get_children()
	for coin in coins:
		if(coin.collected):
			$Coins.remove_child(coin)
			coin.queue_free()
					
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
		$Crates.add_child(crate)
		
func _on_mob_spawn_timer_timeout() -> void:
	if($Player.get_child_count() == 0):
		return
		
	var player = $Player.get_child(0)
	var playerPosition = player.get_node("CharacterBody2D").position
	
	if($Mobs.get_child_count() < 100):
		var rand = RandomNumberGenerator.new()
		var screen_size = get_viewport().get_visible_rect().size
		
		var enemiesCount = rand.randi_range(10, 30)
		for i in range(0,enemiesCount):
			var enemyObject = enemyScene.instantiate()
			
			rand.randomize()
			var x = rand.randf_range(0, screen_size.x) + playerPosition.x - screen_size.x/2
			rand.randomize()
			var y = rand.randf_range(0, screen_size.y) + playerPosition.y - screen_size.y/2
			var randomPos = Vector2(x,y)
			
			enemyObject.get_node("CharacterBody2D").position = randomPos
			enemyObject.get_node("CharacterBody2D").speed = rand.randi_range(50, 160)
			$Mobs.add_child(enemyObject)


func _on_debug_timer_timeout() -> void:
	if($Player.get_child_count() == 0):
		return
		
	var player = $Player.get_child(0)
	var playerPosition = player.get_node("CharacterBody2D").position
	
	print(playerPosition)
