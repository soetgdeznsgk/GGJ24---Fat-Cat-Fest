extends HBoxContainer

signal sp_start_game
signal mp_start_game
@onready var PlayButton = %PlayButton
@onready var SPButton = %SPButton
@onready var MPButton = %MPButton

func _on_sp_button_pressed():
	sp_start_game.emit()


func _on_mp_button_pressed():
	mp_start_game.emit()
	
func showPlayButton():
	PlayButton.visible = true
	SPButton.visible = false
	MPButton.visible = false
	%PlayButton.margin_size = get_tree().root.size.x / 5
	
