extends Sprite2D
var nombre= "BuñueloyNatilla"
var moveset = [Enums.Abajo, Enums.Arriba, Enums.Derecha, Enums.Derecha, Enums.Izquierda, Enums.Derecha, Enums.Abajo, Enums.Izquierda, Enums.Arriba]
func _ready():
	if randf() <0.05:
		self.texture=load("res://Sprites/Comidas/Buñuelo - Copy.png")
