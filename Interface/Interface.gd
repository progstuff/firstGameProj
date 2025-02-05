extends CanvasLayer

var coinsCnt = 0

var skillPanel = {}

func collectCoin() -> void:
	coinsCnt += 1
	$Control/HBoxContainer/CoinsCounter.text = str(coinsCnt)

func levelUp(level: int, levelExpereance: int):
	$Control/ExpereanceContainer/Level.text = "Уровень " + str(level)
	$Control/ExpereanceContainer/ExperienceBar.max_value = levelExpereance
	$Control/ExpereanceContainer/ExperienceBar.value = 0
	
func changeExpereance(experience: int):
	$Control/ExpereanceContainer/ExperienceBar.value = experience
	
func showSkillsLvlUpForPlayer():
	$SkillsPanelScene.generateSkills()
	$SkillsPanelScene.visible = true

func learnSkill(skillInd: int, skillLevel: int, skillIcon: CompressedTexture2D) -> void:
	if(!skillPanel.has(skillInd)):
		var ind = skillPanel.size()
		skillPanel[skillInd] = [skillLevel, ind]
		var panel = $Control/MarginContainer/GridContainer
		panel.get_child(ind).texture = skillIcon
	
	
