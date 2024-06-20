extends Node2D

@export var regenerationAmount: int = 20


func _ready():
	$Area2D.body_entered.connect(onBodyEntered)
	

func onBodyEntered(body: Node2D):
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regenerationAmount)
		
		# Emitindo sinal de que uma meat foi coletada
		player.meatCollected.emit(regenerationAmount)
		queue_free()
