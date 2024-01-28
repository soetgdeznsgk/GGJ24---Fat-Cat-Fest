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

var bufferedInputs : PackedStringArray
var currState := States.Eating # por ahora no hace nada pero
var currDifficulty : int # va de 1 a 3

var referencia_comandos := NodePath("../Comandos") #esto funciona xq cpu se instancia después de que Maingame esté ready

# variables relevantes a rompeplatos
var referencia_rompeplatos := NodePath("../QuickTimeEvent/EventoRomperPlatos")
var is_hammer : bool
var referencia_pos_hammer := NodePath("../QuickTimeEvent/EventoRomperPlatos/Martillo/CollisionShape2D")
var pos_hammer : Vector2
var referencia_pos_dish := NodePath("../QuickTimeEvent/EventoRomperPlatos/Plato:position")
var pos_dish : Vector2
var vectorPenalization := Vector2.ZERO
var vectorOrtonormal : Vector2

# variables relevantes a pepino
var referencia_pepino := NodePath("../QuickTimeEvent/evento_pepino")

# variables relevantes a darseduro
var referencia_darseduro := NodePath("../QuickTimeEvent/EventoDarseDuro")
var can_play := true


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
			break_dishes(1.0)
		Enums.MiniJuegos.DarseDuro: 
			currState = States.DandoseDuro
			get_node(referencia_darseduro).p2_can_hit.connect(set_attack_state)
			fist_fight(1.0)
		Enums.MiniJuegos.Pepino: 
			currState = States.Pepineando
			cucumber(1.0)

#region Behavior Pattern TODO pepino, darseduro

# Funcionamiento regular, LAS FUNCIONES SON SIMILARES, ésta sirve de ejemplo
func eat(cache) -> void:
	if currState == States.Eating: # ésto es lo que interrumpirá la recursión
		if cache is float: # la primera vez que se llama eat() tras un cambio de estado, es siempre mediante eat(1.0)
			$Timer.wait_time = 0.5
			await $Timer.timeout
			$Timer.wait_time = 2 - (currDifficulty / 2) # easy: 1.5 s, med: 1 s, hard: 0.5 s 
			
		if false:#get_node(referencia_comandos).comandosConFlechas.size() == 0 or randf() < 0.7 - (currDifficulty / 10) : #facil: 60% de chance que la cague, med: 50%, dif: 40%
			bufferedInputs.append(Inputs.get(randi_range(0, 3)))
		else:
			bufferedInputs.append(Inputs.get(get_node(referencia_comandos).comandosConFlechas[0])) # 
		
		Input.action_press(bufferedInputs[0])
		await $Timer.timeout
		Input.action_release(bufferedInputs[0])
		bufferedInputs.clear()
		eat(0)
#region Rompeplatos Behavior Pattern

func break_dishes(cache) -> void:
	if currState == States.RompiendoPlatos:
		pos_hammer = get_node(referencia_pos_hammer).global_position
		pos_dish = get_node(referencia_pos_dish).global_position
		
		if cache is float: # osea si es la primera instancia de la recurisón
			$Timer.wait_time = 1.1 - (0.2 * currDifficulty) # 0.9 s easy, 0.7 s mid, 0.5 hard 
			determine_position(get_node(referencia_rompeplatos).p2_started_as_hammer) 
		else: # Conforme pasan llamadas a break_dishe del minijuego, la CPU va teniendo mejor tiempo de reacción
			$Timer.wait_time -= 0.1 * get_physics_process_delta_time() 
		if is_hammer:
			queue_inputs(pos_dish - pos_hammer)
		else:
			vectorOrtonormal = (pos_dish - pos_hammer).orthogonal()
			if pos_dish.x > 1200: 
				vectorPenalization += (pos_dish - pos_hammer).length() * Vector2.LEFT
			elif pos_dish.x < 140: 
				vectorPenalization += (pos_dish - pos_hammer).length() * Vector2.RIGHT
			if pos_dish.y > 600: 
				vectorPenalization += (pos_dish - pos_hammer).length() * Vector2.UP
			elif pos_dish.y < 140: 
				(pos_dish - pos_hammer).length() * Vector2.DOWN
				
			if ((vectorOrtonormal / 3) + pos_dish).x > 1200 or ((vectorOrtonormal / 3) + pos_dish).x < 140 or ((vectorOrtonormal / 3) + pos_dish).y > 600 or ((vectorOrtonormal / 3) + pos_dish).y < 140:
				vectorOrtonormal = - vectorOrtonormal
			#print("pen: ", vectorPenalization, " input: ", vectorPenalization + pos_dish - pos_hammer)
			queue_inputs( (vectorOrtonormal) + vectorPenalization + pos_dish - pos_hammer) # no funciona éste vector
			vectorPenalization = Vector2.ZERO
			
		process_inputs_buffered(Input.action_press)
		await $Timer.timeout
		process_inputs_buffered(Input.action_release)
		bufferedInputs.clear()
		break_dishes(0)
		
func determine_position(isCpuHammer : bool) -> void: #señal
	is_hammer = isCpuHammer
	
func queue_inputs(v) -> void: #ésta función descompone vectores unitarios octogonales, es necesitada por break_dishes
	v = Enums.nearest_octo_vector(v)
	if v is int:
		bufferedInputs.append(Inputs.get(v))
	else:
		bufferedInputs.append(Inputs.get(Enums.nearest_octo_vector(Vector2(v.x, 0) ) ) )
		bufferedInputs.append(Inputs.get(Enums.nearest_octo_vector(Vector2(0, v.y) ) ) )
	
func process_inputs_buffered(metodo : Callable) -> void:
	for i in range(0, bufferedInputs.size() ):
		metodo.call(bufferedInputs[i])
		
#endregion
#region Pepino Behavior Pattern
func cucumber(cache) -> void:
	if currState == States.Pepineando:
		if cache is float:
			bufferedInputs.clear()
			bufferedInputs.append(Inputs.get(Enums.Derecha))
		$Timer.wait_time = currDifficulty / 10 + randf_range(0, .4)
		Input.action_press(bufferedInputs[0])
		await $Timer.timeout
		Input.action_release(bufferedInputs[0])
		cucumber(0)
	
#endregion
#region DarseDuro Behavior Pattern
func fist_fight(cache) -> void:
	if currState == States.DandoseDuro: 
		# hard 0.2-0.4 s, med 0.3-0.6 s, easy 0.5-0.9
		$Timer.wait_time = (10 / ( (9 * currDifficulty) + 5.4) ) + randf_range( - (0.25 - (currDifficulty * 0.05) ), 0.25 - (currDifficulty * 0.05))
		if cache is float:
			bufferedInputs.clear()
			bufferedInputs.append(Inputs.get(Enums.Arriba))
			can_play = true
		if can_play:
			if bufferedInputs[0] == Inputs.get(Enums.Abajo):
				bufferedInputs[0] = Inputs.get(Enums.Arriba)
			elif bufferedInputs[0] == Inputs.get(Enums.Arriba):
				bufferedInputs[0] = Inputs.get(Enums.Abajo)
			await $Timer.timeout
			Input.action_press(bufferedInputs[0])
			
			can_play = false
		
		$Timer.wait_time = 0.01 * get_process_delta_time()
		await $Timer.timeout
		if bufferedInputs.size() != 0: # el await puede hacer que se salga del evento y bufferedInputs sea limpiado afuera de la función antes de llegar acá
			Input.action_release(bufferedInputs[0])
		fist_fight(0)

func set_attack_state() -> void:
	can_play = true
#endregion
#endregion

func set_idle() -> void:
	currState = States.Idle
	
func resume_eating(cache) -> void:
	currState = States.Eating
	eat(1.0)
