class_name Enemy
extends Node2D

@onready var healthEnemyProgressBar: ProgressBar = $HealthProgressBar
@onready var damageDigitMarker = $DamageDigitMarker

@export_category("life")
@export var health: int = 5
@export var deathPrefab: PackedScene

@export_category("drops")
@export var dropChange: float = 0.1
@export var dropItems: Array[PackedScene]
@export var dropChances: Array[float]

var maxHealth: int = 10
var damageDigitPrefab: PackedScene

func _ready():
	damageDigitPrefab = preload("res://Misc/damageDigit.tscn")
	
func _process(delta):
	healthEnemyProgressBar.max_value = maxHealth
	healthEnemyProgressBar.value = health
	
func damage(hit: int) -> void:
	health -= hit
	print('dano area')

	#toda vez q tomam dano pisca a cor do inimigo
	modulate = Color.FIREBRICK
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	# Criando e acessando damage digit
	var damageDigit = damageDigitPrefab.instantiate()
	damageDigit.value = hit
	if damageDigitMarker:
		damageDigit.global_position = damageDigitMarker.global_position
	else:
		damageDigit.global_position = global_position
		
	get_parent().add_child(damageDigit)
	
	if health <= 0:
		GameManager.player.killCounter.emit(1)
		die()
	
func die() -> void:
	# Chama o packedScene que  esta a animação da caveira que configurei
	if deathPrefab:
		var deathObject = deathPrefab.instantiate()
		deathObject.position = position
		get_parent().add_child(deathObject)
	
	# Drop itens
	if randf() <= dropChange:
		dropItem()
		
	# Incrementar contador
	GameManager.monsterDefeatedCounter += 1
	
	queue_free()

func dropItem() -> void:
	var drop = getRandomDropItem().instantiate()
	drop.position = position
	get_parent().add_child(drop)
	
	
func getRandomDropItem() -> PackedScene:
	if dropItems.size() == 1:
		return dropItems[0]
		
	var maxChance: float = 0.0
	for dropChance in dropChances:
		maxChance += dropChance
		
	# jogar dado	
	var randonValue = randf() * maxChance
	
	# Girando a roleta
	var needle: float = 0.0
	for i in dropItems.size():
		var dropItem = dropItems[i]
		var dropChance = 1
		if i < dropChances.size():
			dropChance = dropChances[i] 
		#var dropChance = dropChances[i] if i < dropChances.size() else 1	
		if randonValue <= dropChance + needle:
			return dropItem
		needle += dropChance
		
	return dropItems[0]		
