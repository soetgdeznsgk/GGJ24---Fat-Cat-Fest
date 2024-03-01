extends TextureRect

var vp : Viewport
var paused
var currentPath
var topBtn
var botBtn

@onready var paths = {
	"defaultContainer" : {
		"container" : $DefaultContainer,
		"focusBtns" : {
			"top" :  $DefaultContainer/VBoxContainer/continueBtn,
			"low" :  $DefaultContainer/VBoxContainer/mainMenuBtn
		}
	},
	"configContainer" : {
		"container" : $ConfigContainer,
		"focusBtns" : {
			"top" : $ConfigContainer/OptionsPath/masterVolSlider/muteBtn,
			"low" : $ConfigContainer/OptionsPath/optionsPauseBack}
	},
	"confirmContainer" : {
		"container" : $ConfirmContainer,
		"focusBtns" : {
			"top" : $ConfirmContainer/VBoxContainer/HBoxContainer/ConfirmBtn,
			"low" : $ConfirmContainer/VBoxContainer/HBoxContainer/DenyBtn}
	},
}

func change_path(path : String):
	currentPath = path
	for key in paths.keys():
		#Toggle visibility
		paths[key]["container"].visible = (key == path)
	topBtn = paths[path]["focusBtns"]["top"]
	botBtn = paths[path]["focusBtns"]["low"]
	
	#Automatic retoggle if using keyboard
	if (!Globals.mouseToggle): topBtn.grab_focus()

# Called when the node enters the scene tree for the first time.
func _ready():
	vp = get_viewport()
	paused = false
	visible = false

func _input(event):
	# Check if the event is a keyboard event
	if event is InputEventKey:
		Globals.mouseToggle = false
	elif event is InputEventMouseMotion:
		if(Globals.mouseInNode and Globals.focusedNode):
			Globals.mouseToggle = true
			Globals.focusedNode.grab_focus()
		
	if Input.is_action_just_pressed("ui_cancel"):
		if (!paused):
			visible = true
			change_path("defaultContainer")
			get_tree().paused = true
			paused = true
		else:
			if (currentPath=="defaultContainer"):
				visible = false
				get_tree().paused = false
				paused = false
			else:
				change_path("defaultContainer")
	
	if Input.is_action_pressed("ui_up") and !vp.gui_get_focus_owner() and paused:
		topBtn.grab_focus()
		
	if Input.is_action_pressed("ui_down") and !vp.gui_get_focus_owner() and paused:
		botBtn.grab_focus()

func _on_continue_btn_pressed():
	visible = false
	get_tree().paused = false
	paused = false

func _on_options_btn_pressed(): change_path("configContainer")
func _on_main_menu_btn_pressed(): change_path("confirmContainer")
func _on_options_pause_back_pressed(): change_path("defaultContainer")

func _on_confirm_btn_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Escenas/Menus/main.tscn")

func _on_deny_btn_pressed(): change_path("defaultContainer")
