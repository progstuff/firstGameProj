extends CanvasLayer

var coinsCnt = 0
	
func collectCoin() -> void:
	coinsCnt += 1
	$Control/HBoxContainer/CoinsCounter.text = str(coinsCnt)

func levelUp(level: int, levelExpereance: int):
	$Control/ExpereanceContainer/Level.text = "Уровень " + str(level)
	$Control/ExpereanceContainer/ExperienceBar.max_value = levelExpereance
	$Control/ExpereanceContainer/ExperienceBar.value = 0
	
func changeExpereance(experience: int):
	$Control/ExpereanceContainer/ExperienceBar.value = experience
	
