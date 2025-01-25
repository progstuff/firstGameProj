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
		var enemyPosition = enemyCharacter.position
		var direction = enemyPosition.direction_to(playerPosition)
		
		if((enemyPosition - playerPosition).length() < 30):
			direction = Vector2.ZERO
		else:
			direction = direction.normalized()

		enemyCharacter.input_movement = direction
		enemyCharacter.position = enemyCharacter.position + direction*delta*40

func _on_main_menu_start_game() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	var startPlayerPosition = screen_size/2
	$PlayerScene.visible = true
	$PlayerScene.get_node("CharacterBody2D").position = startPlayerPosition

func _on_mob_spawn_timer_timeout() -> void:
	
	var rand = RandomNumberGenerator.new()
	var screen_size = get_viewport().get_visible_rect().size
	
	var playerPosition = $PlayerScene/CharacterBody2D.position
	
	var enemiesCount = rand.randi_range(1, 10)
	for i in range(0,enemiesCount):
		var enemyObject = enemyScene.instantiate()
		
		rand.randomize()
		var x = rand.randf_range(0, screen_size.x)
		rand.randomize()
		var y = rand.randf_range(0, screen_size.y)
		var randomPos = Vector2(x,y)
		
		enemyObject.get_node("CharacterBody2D").position = Vector2(x, y)
		enemyObject.get_node("CharacterBody2D").speed = rand.randi_range(15, 40)
		$Mobs.add_child(enemyObject)
		
		
