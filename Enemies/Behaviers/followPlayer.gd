extends Node

@export var enemySpeed: float = 3

var spriteEnemy: AnimatedSprite2D 
var enemy: Enemy #definido pela classe criada no script

#pegando parente (pawn para usar as funções dele)
func _ready() -> void:
	enemy = get_parent()
	#@onready var spriteEnemy: AnimatedSprite2D = $AnimatedSprite2D
	spriteEnemy = enemy.get_node("AnimatedSprite2D")
	
func _physics_process(delta: float) -> void:
	# Ignorar o game over
	if GameManager.isGameOver: return
	
	#Buscando posição do player
	var playerPosition = GameManager.playerPosition
	
	# Como fazer inimigo ir direto ao player
	var difference = playerPosition - enemy.position
	var inputVector = difference.normalized()
	
	#var inputVector: Vector2 = Vector2(0, 0)
	var targetVelocity = inputVector * enemySpeed * 40.0
	
	# Formula
	# Posições
	# (Player - Enemy) * normalizado
	
	
	enemy.velocity = lerp(enemy.velocity, targetVelocity, 0.05)
	enemy.move_and_slide()
	
	#Rotacionar o sprite
	if inputVector.x > 0:
		spriteEnemy.flip_h = false
	elif inputVector.x < 0:
		spriteEnemy.flip_h = true
