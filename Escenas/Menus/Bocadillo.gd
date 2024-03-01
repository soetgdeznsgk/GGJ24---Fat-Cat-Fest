extends TextureRect

@onready var label = $MarginContainer/Label
@onready var animP = $AnimationPlayer 

func displayText(params = {"text" : "empty text", "time" : 1.0, "fontSize" : 28 }):
	label.text= params["text"]
	label.add_theme_font_size_override("font_size",params["fontSize"])
	animP.play("appear")
	await get_tree().create_timer(params["time"]).timeout
	animP.play("disappear")
	label.text = ""
	label.remove_theme_color_override("font_size")

