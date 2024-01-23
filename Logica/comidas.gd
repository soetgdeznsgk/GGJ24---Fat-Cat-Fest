extends Node2D

const string = "res://Escenas/Recetas/Buñuelo.tscn"
var receta1=preload(string)
var nodoinstanciado=receta1.instantiate()
var nodoinstanciado2=preload("res://Escenas/Recetas/Pan.tscn").instantiate()


# Called when the node enters the scene tree for the first time.
func _ready():
	#spawnea la receta1 en el nodo 'RecetaPlayer1'
	get_child(1).add_child(nodoinstanciado)
	#get_child(0).add_child(nodoinstanciado2)
	
	
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animacion_entrada(1)
	pass
#funcion que cuando se llama se dice si es para el jugador 1 o 2 (0=p1,  1=p2)
func animacion_entrada(player):
	var tween=create_tween()
	var recetaActual
	var direccionMov=Vector2.ZERO
	if player==0:
		recetaActual=get_child(0).get_child(0)
		direccionMov=Vector2(500,0)
	else:
		recetaActual=get_child(1).get_child(0)
		direccionMov=Vector2(-500,0)
	print(recetaActual.name)
	tween.tween_property(recetaActual,"position",direccionMov,0.5)
	#tween que mueve a la receta actual
	
	#primero va a recetaPlayer1 y despues busca la primera receta que este
