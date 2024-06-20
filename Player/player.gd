class_name Player
extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var sprite2d: Sprite2D = $Sprite2D
@onready var SwordArea: Area2D = $SwordArea
@onready var hitBoxArea: Area2D = $DamageArea

#Tentar jogar o p´rogress life bar no system script para que fique 
#fixo na tela do jogo e nao no player
@onready var healthProgressBar: ProgressBar = $HealthPlayerProgressBar

@export_category("Movement")
@export var speed: float = 3

@export_category("Weapon")
@export var swordDamage: int = 2

@export_category("Powers")
@export var powerDamage: int = 2
@export var powerInterval: float = 30
@export var powerScene: PackedScene


@export_category("Life")
@export var health: int = 100
@export var deathPrefab: PackedScene

var inputVector: Vector2 = Vector2(0, 0)
var isRunning: bool = false
var isAttacking: bool = false
var attackCooldown: float = 0.0
var hitBoxCooldown: float = 0.0
var maxHealth:int = 100
var powerCooldown: float = 0.0

signal meatCollected(value:int)
signal killCounter(value:int)
# Precisa fazer scrip e cena do gold
signal goldCounter(value:int)

func _ready():
	GameManager.player = self
	meatCollected.connect(func(value:int): GameManager.meatCount += 1)
	killCounter.connect(func(value:int): GameManager.killCounter += 1)
	
func _process(delta: float ) -> void:
	#adicionando position para singletons
	GameManager.playerPosition = position
	readInput()
	
	if isAttacking:
		attackCooldown -= delta
		if attackCooldown <= 0.0:
			isAttacking = false
			isRunning = false
			animationPlayer.play("Iddle")
				
	#processar o dano
	updateHitBoxDetection(delta)	
		
	#Power Move
	updatePower(delta)
	
	# Atualizar o health bar
	healthProgressBar.max_value = maxHealth
	healthProgressBar.value = health
	
func _physics_process(delta: float) -> void:
	var targetVelocity = inputVector * speed * 100.0
	
	if isAttacking:
		targetVelocity *= 0.25
	 	
	velocity = lerp(velocity, targetVelocity, 0.05)
	move_and_slide()
	

	#atualizando o isRunning
	var wasRunning = isRunning
	isRunning = not inputVector.is_zero_approx()
	
	if not isAttacking:
		if wasRunning != isRunning:
			if isRunning:
				animationPlayer.play("Run")
			else:
				animationPlayer.play("Iddle")	
	
	#girar sprite
	if not isAttacking:
		if inputVector.x > 0:
			sprite2d.flip_h = false
		elif inputVector.x < 0:
			sprite2d.flip_h = true

			
func readInput() -> void:
	inputVector = Input.get_vector("move_left","move_right","move_up","move_down")
	
	#apagar deadzone do input para controle
	var deadzone = 0.15
	if abs(inputVector.x) < deadzone:
		inputVector.x = 0.0
	if abs(inputVector.y) < deadzone:
		inputVector.y = 0.0
	
	#verificar se o player clicou na ação atacar
	if Input.is_action_just_pressed("ButtonAttack"):
			attack()
	
func attack() -> void:
	if isAttacking:
		return
		
	animationPlayer.play("AttackSide1")
	attackCooldown = 0.7
	isAttacking = true
	
func updatePower(delta: float) -> void:
	powerCooldown -= delta
	if powerCooldown > 0: return
	powerCooldown = powerInterval
	
	var power = powerScene.instantiate()
	power.damageAmount = powerDamage
	add_child(power)

func updateHitBoxDetection(delta: float) -> void:
	#processar o acerto de golpe do inimigo mas com frequencia
	hitBoxCooldown -= delta 
	if hitBoxCooldown > 0:
		return
		
	hitBoxCooldown = 0.5
	
	#detectar inimigos	
	var bodies = hitBoxArea.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("enemiesGroup"):
			var enemy: Enemy = body
			var damageAmount = 10 #sera mudado depois
			damage(damageAmount)
			
#função sendo chamado no AnimationPlayer
#definido em um tempo da ação.
func damage2Enemies() -> void:
	#detectando o corpo do collision do enemy com bodies
	var bodies = SwordArea.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("enemiesGroup"):
			var enemy: Enemy = body
			
			var direction2Enemy = (enemy.position - position)
			var attackDirection: Vector2
			
			if sprite2d.flip_h:
				attackDirection = Vector2.LEFT
			else:
				attackDirection = Vector2.RIGHT
				
			var dotProduct = direction2Enemy.dot(attackDirection)
			
			if dotProduct >= 0.3:
				enemy.damage(swordDamage)
			
	#acessando todos inimigos pelo grupo
	#var enemiesGroup = get_tree().get_nodes_in_group("enemiesGroup")
	
	#for enemy in enemiesGroup:
	#	enemy.damage(swordDamage)
	
func damage(hit: int) -> void:
	if health <= 0: return
	
	health -= hit
	print('dano recebido de: ', hit)

	#toda vez q tomam dano pisca a cor do inimigo
	modulate = Color.FIREBRICK
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	if health <= 0:
		die()
	
func die() -> void:
	# Chamaria a tela game over UI
	GameManager.endGame()
	
	#chama o packedScene que  esta a animação da caveira que configurei
	if deathPrefab:
		var deathObject = deathPrefab.instantiate()
		deathObject.position = position
		get_parent().add_child(deathObject)
	
	print('player morreu')
	queue_free()
	
func heal(amount: int) -> int:
	print('atual vida:', health)
	health += amount
	
	if(health > maxHealth):
		health = maxHealth
		
	print('recuperada vida:', health)
	return health
