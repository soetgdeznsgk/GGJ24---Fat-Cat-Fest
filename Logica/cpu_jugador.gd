extends Node

enum States{
	Eating,
	RompiendoPlatos,
	DandoseDuro,
	Pepineando,
	Idle
}
var Inputs := { # en el mismo orden que enums.direcciones
	0 : "ArribaPj2",
	1 : "AbajoPj2",
	2 : "IzquierdaPj2",
	3 : "DerechaPj2"
}

var bufferedInput : String
var currState := States.Eating # por ahora no hace nada pero
var currDifficulty : int # va de 1 a 3

var referencia_comandos := NodePath("../Comandos") #esto funciona xq cpu se instancia después de que Maingame esté ready

# variables relevantes a rompeplatos
var referencia_rompeplatos := NodePath("../QuickTimeEvent/EventoRomperPlatos")
var is_hammer : int
var referencia_pos_hammer := NodePath("../QuickTimeEvent/EventoRomperPlatos/Martillo/CollisionShape2D")
var pos_hammer : Vector2
var referencia_pos_dish := NodePath("../QuickTimeEvent/EventoRomperPlatos/Plato:position")
var pos_dish : Vector2

# variables relevantes a pepino
var referencia_pepino := NodePath("../QuickTimeEvent/evento_pepino")

# variables relevantes a darseduro
var referencia_darseduro := NodePath("../QuickTimeEvent/evento_darse_duro")


func set_difficulty() -> void:
	currDifficulty = randi_range(1, 3)
	

func _enter_tree() -> void:
	Eventos.nuevoEvento.connect(minigame_entered)
	Eventos.finalEvento.connect(resume_eating)
	Eventos.bajarTelon.connect(set_idle)
	
	set_difficulty()
	eat(1.0)
	print("cpu difficulty: ", currDifficulty, " / 3")
	
	
func minigame_entered(activity : int) -> void:
	match activity:
		Enums.MiniJuegos.RomperPlatos:
			currState = States.RompiendoPlatos
			get_node(referencia_rompeplatos).is_p2_hammer.connect(determine_position)
			#referencia_pos_hammer = get_node(referencia_rompeplatos).MartilloHB_pos
			#referencia_pos_dish =  get_node(referencia_rompeplatos).Plato_pos
			
			break_dishes(1.0)
		Enums.MiniJuegos.DarseDuro: 
			currState = States.DandoseDuro
		Enums.MiniJuegos.Pepino: 
			currState = States.Pepineando

#region Behavior Pattern TODO pepino, darseduro
func eat(cache) -> void:
	if currState == States.Eating:
		if cache is float: #mandar eat(i: float) solo cuando comience el estado eating
			$Timer.wait_time = 2 - (currDifficulty / 2) # easy: 1.5 s, med: 1 s, hard: 0.5 s 
			
		if get_node(referencia_comandos).comandosConFlechas.size() == 0 or randf() < 0.7 - (currDifficulty / 10) : #facil: 60% de chance que la cague, med: 50%, dif: 40%
			bufferedInput = Inputs.get(randi_range(0, 3))
			Input.action_press(bufferedInput)
		else:
			#get_node(referencia_comandos).comandosConFlechas
			bufferedInput = Inputs.get(get_node(referencia_comandos).comandosConFlechas[0])
			Input.action_press(bufferedInput)
		Input.action_release(bufferedInput)
		await $Timer.timeout
		eat(0) #funciona?

func break_dishes(cache) -> void:
	if currState == States.RompiendoPlatos:
		pos_hammer = get_node(referencia_pos_hammer).global_position
		pos_dish = get_node(referencia_pos_dish).global_position
		if cache is float:
			$Timer.wait_time = 1#
		if is_hammer:
			print("reacciono siendo martillo")
		else:
			# el siguiente vector es un vector perpendicular a al vector entre pos_hammer y pos_dish
			bufferedInput = Inputs.get(Enums.vector_to_value( (pos_dish - pos_hammer).orthogonal()))
			print("como plato, me muevo a ", bufferedInput)
			#bufferedInput = Inputs.get(Enums.vector_to_value()))
			Input.action_press(bufferedInput)

		await $Timer.timeout
		Input.action_release(bufferedInput)
		break_dishes(0) # funciona?
		
func determine_position(isCpuHammer : bool) -> void: #señal
	is_hammer = isCpuHammer
	
func cucumber(cache) -> void:
	pass
	
func fist_fight(cache) -> void:
	pass
	
#endregion

func set_idle() -> void:
	currState = States.Idle
	
func resume_eating(cache) -> void:
	currState = States.Eating
	eat(1.0)
