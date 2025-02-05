extends MarginContainer

@export var level = 1	
@export var ind = 0

func setSkill(index: int, image: CompressedTexture2D, lvl: int) -> void:
	var icon = $PanelContainer/HBoxContainer/PanelContainer/Icon
	icon.texture = image
	level = lvl
	ind = index
	$PanelContainer/HBoxContainer/PanelContainer/Level.text = str(lvl)


func _on_h_box_container_mouse_entered() -> void:
	pass

func _on_h_box_container_mouse_exited() -> void:
	pass
	
func _on_timer_timeout() -> void:
	pass

func _on_h_box_container_gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and not event.is_pressed()
	):
		var icon = $PanelContainer/HBoxContainer/PanelContainer/Icon
		get_parent().get_parent().learnSkill(ind, level, icon.texture)
		get_parent().get_parent().visible = false

func _on_icon_gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and not event.is_pressed()
	):
		var icon = $PanelContainer/HBoxContainer/PanelContainer/Icon
		get_parent().get_parent().learnSkill(ind, level, icon.texture)
		get_parent().visible = false
