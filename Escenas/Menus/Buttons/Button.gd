extends boton_simple
class_name animated_button

@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var sfx_audio := AudioStreamPlayer.new()

var seeker = 0
var backwards = false
var forward = false

signal animacion_play(tween: Tween)

@warning_ignore("integer_division")
@onready var margin_size = get_tree().root.size.x / 5

func _ready() -> void:
	sfx_audio.bus = "SFX"
	sfx_audio.stream = load("res://Escenas/Menus/sfx/button_standard.wav")
	self.add_child(sfx_audio)

func _on_mouse_entered():
	super._on_mouse_entered()
	if anim.is_playing():
		seeker = anim.current_animation_position
	else:
		seeker = 0
	if !forward:
		anim.play("slide")
		forward = true
		backwards = false
		anim.seek(seeker)

func _on_mouse_exited():
	super._on_mouse_exited()
	if anim.is_playing():
		seeker = anim.current_animation_position
	else:
		seeker = 0
	if !backwards:
		anim.seek(seeker)
		anim.play_backwards("slide")
		forward = false
		backwards = true

func _on_focus_entered() -> void:
	_on_mouse_entered()

func _on_focus_exited() -> void:
	_on_mouse_exited()

func _on_pressed() -> void: # intentar moverlo con el margen y no con el size
	sfx_audio.play()
	$"../SPButton".grab_focus()
	hide()
	$"../SPButton".show()
	$"../MPButton".show()
	
	$"../../..".isDeveloped = true
	$"../..".add_theme_constant_override("margin_left", margin_size)
	$"../..".add_theme_constant_override("margin_right", margin_size)
	#print("margin_size = ", margin_size)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "margin_size", 0, 0.5)
	animacion_play.emit(tween)
	tween_margins_forcefully(tween)
	
func tween_margins_forcefully(tween : Tween): # CODIGO RADIOACTIVO
	if tween.is_running():
		$"../..".add_theme_constant_override("margin_left", margin_size)
		$"../..".add_theme_constant_override("margin_right", margin_size)
		if get_tree(): # si se elimina éste se caga encima la secuencia de cambio a maingame
			#if get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1).name == "Control":
			await get_tree().create_timer(0.01).timeout
			tween_margins_forcefully(tween)
