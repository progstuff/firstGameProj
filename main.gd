extends Node2D
var enemyScene = load("res://Enemy/EnemyScene.tscn")
var playerScene = load("res://Player/PlayerScene.tscn")
var mapScene = load("res://Map/MapScene.tscn")

var CHUNK_HEIGHT = 40 * 16
var CHUNK_WIDTH = 72 * 16
var tileMap = {Vector2(0, 0): true}

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
	
	generateTerrain()		

func generateTerrain() -> void:
	if($Player.get_child_count() == 0):
		return
		
	var player = $Player.get_child(0)
	var playerPosition = player.get_node("CharacterBody2D").position
	
	playerPosition = playerPosition + Vector2(200, -200);
	
	var x = floor(playerPosition.x / CHUNK_WIDTH)
	var y = floor(playerPosition.y / CHUNK_HEIGHT)
	var chunkCoord = Vector2(x, y)
	
	if(!tileMap.has(chunkCoord)):
		var chunk = mapScene.instantiate()
		chunk.position.x = x * CHUNK_WIDTH
		chunk.position.y = y * CHUNK_HEIGHT
		$Map.add_child(chunk)
		tileMap[chunkCoord] = true
		
	
	
func _on_main_menu_start_game() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	var startPlayerPosition = screen_size/2
	var chunk = mapScene.instantiate()
	$Map.add_child(chunk)
	
	var player = playerScene.instantiate()
	$Player.add_child(player)
	
	player.get_node("CharacterBody2D").position = startPlayerPosition
	$MobSpawnTimer.start()

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
