extends Node

var name_player1
var name_player2
var nameinitial : Array = ["Silly", "Tiny", "Huge", "The", "Cute", "Nonsensical", "Addictive", "Smol", "Sad", "Baby", "Eepy", "Anxious", "Crazy", "Golden", "Ex-convict"]
var namefinal : Array = ["Car", "Kitty", "WAR CRIMINAL", "Chonker", "Purrer", "Bingus", "Microplastic Enjoyer", "Mulch", "Yippie", "Nyan", "Hobo", "Messi", "Karen Adopted", "Paw Sniffer"]

# Al iniciarse el singleton toma un nombre random, tambien al darle play al juego
# lo pongo aca para que no se rompa al probar escenas solitas
func _ready() -> void:
	Names.name_player1 = Names.nameinitial.pick_random() + " " + Names.namefinal.pick_random()
	Names.name_player2 = Names.nameinitial.pick_random() + " " + Names.namefinal.pick_random()
	pass
