class_name MobSpawner
extends Node2D

@export var creatures: Array[PackedScene]
@export var mobsPerMinute: float = 60.0

@onready var pathFollow2d: PathFollow2D = %PathFollow2D

var cooldown: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# Ignorar o game over
	if GameManager.isGameOver: return
	
	# Temporizador (cooldown)
	cooldown -= delta
	if cooldown > 0: return
	
	# Frequenciade spawn
	var interval = 60.0 / mobsPerMinute
	cooldown = interval

	# Checar se o ponto do spawn é valido
	# Não irá spawnar monstros fora da area
	var point = getPoint()
	var worldState = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	
	parameters.position = point
	# Definindo mask do collision em bit da posição
	parameters.collision_mask = 0b1001
	
	var result: Array = worldState.intersect_point(parameters, 1)
	print('result: ', result.is_empty())
	if not result.is_empty(): 
		return
	
	# Instanciar uma creatura random
	var index = randi_range(0, creatures.size() - 1)
	var creatureScene = creatures[index]
	var creature = creatureScene.instantiate()

	creature.global_position = getPoint()
	
	# Adicionando a criature no parent TestMobSpawning
	get_parent().add_child(creature)
	
	
#seta valor aleatorio do vector randomico e 
#seta a posição onde o inimigo será spawnado
func getPoint() -> Vector2:
	pathFollow2d.progress_ratio = randf()
	return pathFollow2d.global_position
