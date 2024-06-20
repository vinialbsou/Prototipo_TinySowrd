extends CanvasLayer

@onready var timerLabel: Label = %Timer
@onready var goldLabel: Label = %Golds
@onready var killLabel: Label = %Kills
@onready var meatLabel: Label = %Meat

func _process(delta: float):
	timerLabel.text = GameManager.timeElapseString
	meatLabel.text = str(GameManager.meatCount)
	killLabel.text = str(GameManager.killCounter)
