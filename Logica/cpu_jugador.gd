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

var currState := States.Eating
var currDifficulty : int # va de 1 a 3, en 0 no hace nada

var referencia_comandos = NodePath("../Comandos") #esto funciona xq cpu se instancia después de que Maingame esté ready

func set_difficulty():
	currDifficulty = randi_range(1, 3)
	$Timer.wait_time = 2.7 - sqrt(currDifficulty) # easy: 1.7 s, med: 1.3 s, hard: 1 s

func _enter_tree():
	print("cpu instanciada")
	Eventos.nuevoEvento.connect(minigame_entered)
	Eventos.finalEvento.connect(eat)
	eat(1)
	set_difficulty()
	print(currDifficulty)
	
	
func minigame_entered(activity : int):
	match activity:
		Enums.MiniJuegos.RomperPlatos:
			currState = States.RompiendoPlatos
		Enums.MiniJuegos.DarseDuro: 
			currState = States.DandoseDuro
		Enums.MiniJuegos.Pepino: 
			currState = States.Pepineando

func eat(cache):
	if randf() < 0.7 - (currDifficulty / 10) : #facil: 60% de chance que la cague, med: 50%, dif: 40%
		Input.action_press(Inputs.get(randi_range(0, 3)))
		
	else:
		if get_node(referencia_comandos).comandosConFlechas:
			Input.action_press(Inputs.get(get_node(referencia_comandos).comandosConFlechas[0]))
		pass
	await $Timer.timeout
	Input.action_release(Inputs.get(get_node(referencia_comandos).comandosConFlechas[0]))
	eat(cache)
	
func _process(_delta):
	pass
