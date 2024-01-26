extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = Names.name_player1
	Eventos.nuevoEvento.connect(pausarProcesos)
	Eventos.finalEvento.connect(reanudarProcesos)

func pausarProcesos():
	visible = false

func reanudarProcesos():
	visible = true
