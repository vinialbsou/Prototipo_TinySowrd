extends Node

@export var mobSpawner: MobSpawner
@export var initialSpawnRate: float = 60
@export var spawnRatePerMinute: float = 30
@export var waveDuration: float = 20
@export var breakIntensity: float = 0.5

var time: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Ignorar o game over
	if GameManager.isGameOver: return
	
	time += delta
	
	var calculateSpawnRate = initialSpawnRate + (spawnRatePerMinute * (time / 60.0))
	
	# Calculando a wave
	var sinWave = sin((time * TAU) / waveDuration)
	var waveFactor = remap(sinWave, -1.0, 1.0, breakIntensity, 1)

	calculateSpawnRate += waveFactor
	
	# Vindo do script mobSpawner
	# Aplica a dificuldade
	mobSpawner.mobsPerMinute = calculateSpawnRate

