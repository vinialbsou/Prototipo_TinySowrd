class_name GameOverUI
extends CanvasLayer

@onready var timeLabel: Label = %TimeLabel
@onready var monsterLabel: Label = %MonsterLabel

@export var restartDelay: float = 5.0
var restartCooldown: float

func _ready():
	timeLabel.text = GameManager.timeElapseString
	monsterLabel.text = str(GameManager.monsterDefeatedCounter)
	restartCooldown = restartDelay
	
func _process(delta):
	restartCooldown -= delta
	if restartCooldown <= 0.0:
		restartGame()
		
func restartGame():
	GameManager.reset()
	get_tree().reload_current_scene()
