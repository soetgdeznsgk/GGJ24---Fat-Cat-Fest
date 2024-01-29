extends HBoxContainer

signal sp_start_game
signal mp_start_game
@onready var PlayButton = %PlayButton
@onready var SPButton = %SPButton
@onready var MPButton = %MPButton
var isDeveloped := false
var sig : Tween

func _on_sp_button_pressed():
	sp_start_game.emit()


func _on_mp_button_pressed():
	mp_start_game.emit()
	
func showPlayButton():
	isDeveloped = false
	PlayButton.visible = true
	SPButton.visible = false
	MPButton.visible = false
	if sig:
		sig.stop()
	PlayButton.margin_size = get_tree().root.size.x / 5
	$MarginContainer.add_theme_constant_override("margin_left", 0)
	$MarginContainer.add_theme_constant_override("margin_right", 0)
	
func _on_play_button_animacion_play(tween):
	sig = tween
