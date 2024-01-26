extends Node

enum States{
	Eating,
	RompiendoPlatos,
	DandoseDuro,
	Pepineando
}
var Inputs := {
	0 : "ArribaPj1",
	1 : "AbajoPj1",
	2 : "IzquierdaPj1",
	3 : "DerechaPj1"
}

var bufferedInput : String
var currState := States.Eating # por ahora no hace nada pero
var currDifficulty : int # va de 1 a 3

var referencia_comandos := NodePath("../Comandos") #esto funciona xq cpu se instancia después de que Maingame esté ready

func set_difficulty() -> void:
	currDifficulty = randi_range(1, 3)
	$Timer.wait_time = 2 - (currDifficulty / 2) # easy: 1.5 s, med: 1 s, hard: 0.5 s

func _enter_tree() -> void:
	print("cpu instanciada")
	Eventos.nuevoEvento.connect(minigame_entered)
	Eventos.finalEvento.connect(eat)
	set_difficulty()
	eat(1)
	print(currDifficulty)
	
	
func minigame_entered(activity : int) -> void:
	match activity:
		Enums.MiniJuegos.RomperPlatos:
			currState = States.RompiendoPlatos
		Enums.MiniJuegos.DarseDuro: 
			currState = States.DandoseDuro
		Enums.MiniJuegos.Pepino: 
			currState = States.Pepineando

func eat(cache) -> void: # cache solo es necesario para que pueda ser llamado con la señal finalEvento(ganador)
	if get_node(referencia_comandos).comandosConFlechas.size() == 0 or randf() < 0.7 - (currDifficulty / 10) : #facil: 60% de chance que la cague, med: 50%, dif: 40%
		bufferedInput = Inputs.get(randi_range(0, 3))
		Input.action_press(bufferedInput)
	else:
		#get_node(referencia_comandos).comandosConFlechas
		bufferedInput = Inputs.get(get_node(referencia_comandos).comandosConFlechas[0])
		Input.action_press(bufferedInput)
	Input.action_release(bufferedInput)
	await $Timer.timeout
	eat(cache)
