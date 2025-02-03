extends CanvasLayer

var coinsCnt = 0

func collectCoin() -> void:
	coinsCnt += 1
	$Control/HBoxContainer/CoinsCounter.text = str(coinsCnt)
