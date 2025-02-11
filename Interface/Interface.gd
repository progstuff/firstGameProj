extends CanvasLayer

var abilityScene = load("res://Interface/SlotScene.tscn")
var coinsCnt = 0

var skillPanel = {}
var currentSeconds = 0

func init() -> void:
	var panel = $Control/MarginContainer/AbilityPanel
	for n in panel.get_children():
		panel.remove_child(n)
		n.queue_free()
	skillPanel.clear()
	
	coinsCnt = 0
	currentSeconds = 0
	
	$Control/TimeCounter/Time.text = "00:00"
	
	var coinsCounterLbl = $Control/CoinsCounterContainer/HBoxContainer/CoinsCounter
	coinsCounterLbl.text = str(coinsCnt)
	
	$Control/TimeCounter/Timer.start()
	visible = true
	
func collectCoin() -> void:
	coinsCnt += 1
	var coinsCounterLbl = $Control/CoinsCounterContainer/HBoxContainer/CoinsCounter
	coinsCounterLbl.text = str(coinsCnt)

func levelUp(level: int, levelExpereance: int):
	$Control/ExpereanceContainer/Level.text = "Уровень " + str(level)
	$Control/ExpereanceContainer/ExperienceBar.max_value = levelExpereance
	$Control/ExpereanceContainer/ExperienceBar.value = 0
	
func changeExpereance(experience: int):
	$Control/ExpereanceContainer/ExperienceBar.value = experience
	
func showSkillsLvlUpForPlayer():
	$SkillsPanelScene.generateSkills()
	$SkillsPanelScene.visible = true
	get_tree().paused = true

func learnSkill(skillInd: int, skillLevel: int, skillIcon: CompressedTexture2D) -> void:
	var panel = $Control/MarginContainer/AbilityPanel
	if(!skillPanel.has(skillInd)):
		var ind = skillPanel.size()
		skillPanel[skillInd] = [skillLevel, ind]
		var ability = abilityScene.instantiate()
		ability.setAbility(skillIcon, skillLevel)
		panel.add_child(ability)
	else:
		var ind = skillPanel[skillInd][1]
		panel.get_child(ind).increaseLevel()
	get_tree().paused = false

func _on_timer_timeout() -> void:
	currentSeconds += 1
	var seconds = currentSeconds % 60
	var minutes = (currentSeconds - seconds)/60
	
	var secStr = str(seconds)
	if(seconds < 10):
		secStr = "0" + secStr
		
	var minStr = str(minutes)
	if(minutes < 10):
		minStr = "0" + minStr
	
	$Control/TimeCounter/Time.text = minStr + ":" + secStr
