extends Node

@export var gameUI: CanvasLayer
@export var GameOverTemplateUI: PackedScene

func _ready():
	GameManager.gameOver.connect(triggerGameOver)
	
func triggerGameOver():
	# Remover GameUi
	if gameUI:
		gameUI.queue_free()
		gameUI = null

	#chamar GameOverUI
	var gameOverTemplate: GameOverUI = GameOverTemplateUI.instantiate()
	add_child(gameOverTemplate)
