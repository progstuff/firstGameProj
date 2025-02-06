extends PanelContainer

@export var level = 0

func setAbility(icon:CompressedTexture2D, lvl: int):
	$Icon.texture = icon
	level = lvl
	$Level.text = str(level)
	
func increaseLevel():
	level += 1
	$Level.text = str(level)
