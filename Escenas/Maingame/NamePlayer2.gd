extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = Names.name_player2
	Eventos.nuevoEvento.connect(pausarProcesos)
	Eventos.finalEvento.connect(reanudarProcesos)

func pausarProcesos(_arg):
	visible = false

func reanudarProcesos(_arg):
	visible = true
