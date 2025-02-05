extends VBoxContainer

var skillScene = load("res://Interface/Skills/SkillScene.tscn")

var skill1 = preload("res://Interface/Skills/Icon_01.png")
var skill2 = preload("res://Interface/Skills/Icon_02.png")
var skill3 = preload("res://Interface/Skills/Icon_03.png")
var skill4 = preload("res://Interface/Skills/Icon_04.png")
var skill5 = preload("res://Interface/Skills/Icon_05.png")
var skill6 = preload("res://Interface/Skills/Icon_06.png")
var skill7 = preload("res://Interface/Skills/Icon_07.png")
var skill8 = preload("res://Interface/Skills/Icon_08.png")
var skill9 = preload("res://Interface/Skills/Icon_09.png")

var skills = [
	skill1, skill2, skill3, 
	skill4, skill5, skill6, 
	skill7, skill8, skill9]

var bannedInd = []

func addSkill() -> void:
	var skill = skillScene.instantiate()
	while(1):
		var ind = randi_range(0, 8)
		if(!bannedInd.has(ind)):
			skill.setSkill(ind, skills[ind], 1)
			bannedInd.append(ind)
			break
	
	add_child(skill)

func generateSkills() -> void:
	for child in get_children():
		child.queue_free()
	
	bannedInd.clear()
	for i in range(0, 5):
		addSkill()
	
