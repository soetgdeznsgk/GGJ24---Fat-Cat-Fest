extends HBoxContainer

signal sp_start_game
signal mp_start_game

func _on_sp_button_pressed():
	sp_start_game.emit()


func _on_mp_button_pressed():
	mp_start_game.emit()
	
