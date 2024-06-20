extends Node2D

@export var value: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Definido no Label do menu cena a direita
	# Opção %Acesso Nome unico para acessar conforme abaixo
	%Label.text = str(value)
