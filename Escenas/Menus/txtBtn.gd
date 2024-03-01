extends Button

@export var btnText : String

@onready var audioPlayer = $ButtonPress
@onready var label = $Label
@onready var animP = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = btnText

func _on_focus_entered():
	animP.play("slideIn")

func _on_focus_exited():
	animP.play("slideOut")
	
func _on_mouse_entered(): Globals.mouseGrabFocus(self)
func _on_mouse_exited(): Globals.mouseReleaseFocus()
	
func _on_pressed():
	audioPlayer.play()
