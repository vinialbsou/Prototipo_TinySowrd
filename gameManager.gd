extends Node

signal gameOver

var player: Player

# Singletons adicionado no autoload do godot
# Projeto > Configurações do Projeto > Autoload
var playerPosition: Vector2
var isGameOver: bool = false

var timeElapsed: float = 0.0
var timeElapseString: String
var meatCount: int = 0
var killCounter: int = 0
var monsterDefeatedCounter: int = 0
	
func _process(delta: float):
	timeElapsed += delta
	var timeElapsedInSeconds: int = floori(timeElapsed)
	
	# divisão com restante com a operação %
	var seconds: int = timeElapsedInSeconds % 60
	# Somente divide
	var minutes: int = timeElapsedInSeconds / 60
	
	# Formatação Godot para Temp 'd' significa digitos 
	# '02 siginifica dois digitos
	# % dentro seria os valores das variaves
	timeElapseString = "%02d:%02d" % [minutes, seconds]


func endGame():
	if isGameOver: return
	
	isGameOver = true
	gameOver.emit()

func reset():
	player = null
	playerPosition = Vector2.ZERO
	isGameOver = false
	print("reset")
	timeElapsed = 0.0
	timeElapseString = "00:00"
	meatCount = 0
	killCounter = 0
	monsterDefeatedCounter = 0
	
	for connection in gameOver.get_connections():
		gameOver.disconnect(connection.callable)
