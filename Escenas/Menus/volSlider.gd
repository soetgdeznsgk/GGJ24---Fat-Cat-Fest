extends HBoxContainer

@export var label_bus : String
@export var bus_name: String

@onready var slider = $HSlider
@onready var busNameLabel = $bus_name
@onready var muteBtn = $muteBtn
@onready var volEdit = $volEdit

var bus_index: int

func _ready() -> void:
	busNameLabel.text = label_bus
	bus_index = AudioServer.get_bus_index(bus_name)
	volEdit.value = slider.value*100
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))


func _on_h_slider_value_changed(value):
	muteBtn.set_pressed(false)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	volEdit.value = value*100

func _on_mute_btn_toggled(toggled_on): AudioServer.set_bus_mute(bus_index, toggled_on)
func _on_vol_edit_value_changed(value): slider.value = volEdit.value/100
func _on_mute_btn_mouse_entered(): Globals.mouseGrabFocus(muteBtn)
func _on_mute_btn_mouse_exited(): Globals.mouseReleaseFocus()

