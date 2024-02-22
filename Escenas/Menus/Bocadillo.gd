extends TextureRect

@onready var label = $MarginContainer/Label
@onready var animP = $AnimationPlayer 

# params [0] := text , params[1] := time
func displayText(params: Array):
	label.text= params[0]
	animP.play("appear")
	await get_tree().create_timer(params[1]).timeout
	animP.play("disappear")
	label.text = ""
