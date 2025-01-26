extends Node2D
var enemyScene = load("res://Enemy/EnemyScene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	var playerPosition = $PlayerScene/CharacterBody2D.position
	var enemies = $Mobs.get_children()
	for enemy in enemies:
		var enemyCharacter = enemy.get_node("CharacterBody2D")
		if(enemyCharacter.live == 0):
			$Mobs.remove_child(enemy)
			enemy.queue_free()
		else:
			var enemyPosition = enemyCharacter.position
			var direction = enemyPosition.direction_to(playerPosition)
			
			if((enemyPosition - playerPosition).length() < 30):
				direction = Vector2.ZERO
			if(enemyCharacter.live <= 0):
				direction = Vector2.ZERO

			direction = direction.normalized()
			
			enemyCharacter.input_movement = direction
			enemyCharacter.position = enemyCharacter.position + direction*delta*enemyCharacter.speed
			

func _on_main_menu_start_game() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	var startPlayerPosition = screen_size/2
	$PlayerScene.visible = true
	$PlayerScene.get_node("CharacterBody2D").position = startPlayerPosition
	$MobSpawnTimer.start()

func _on_mob_spawn_timer_timeout() -> void:
	
	if($Mobs.get_child_count() < 100):
		var rand = RandomNumberGenerator.new()
		var screen_size = get_viewport().get_visible_rect().size
		
		var enemiesCount = rand.randi_range(10, 30)
		for i in range(0,enemiesCount):
			var enemyObject = enemyScene.instantiate()
			
			rand.randomize()
			var x = rand.randf_range(0, screen_size.x)
			rand.randomize()
			var y = rand.randf_range(0, screen_size.y)
			var randomPos = Vector2(x,y)
			
			enemyObject.get_node("CharacterBody2D").position = randomPos
			enemyObject.get_node("CharacterBody2D").speed = rand.randi_range(20, 80)
			$Mobs.add_child(enemyObject)
		
		
