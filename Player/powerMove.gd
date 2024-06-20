extends Node2D

@export var damageAmount: int = 1

@onready var area2d: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func deal_damage() -> void:
	var bodies = area2d.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("enemiesGroup"):
			var enemy: Enemy = body
			enemy.damage(damageAmount)
	
