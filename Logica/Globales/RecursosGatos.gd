extends Node

#VALORES DEFAULT
#TODO: CAMBIAR ESTAS GLOBALES DESDE LA PJ SELECTION SCREEN
var catSelectionP1 : String = "Timmy" 
var catSelectionP2 : String = "Miguel"

@onready var recursos = {
	"Timmy" : {
			"versusScreen" : "",
			"mainGame" : { 	"anims" : preload("res://RecursosGatos/Maingame_Timmy.tres"),
							"positionLeft" : [136,-298],
							"positionRight" : [148,-298],
							"scale" : Vector2(0.6, 0.6),
							"sonidos" : {
								"stunned" 	: loadResources("res://SFX/GatoProta/Stunned/", 
								["1.mp3"]),
								"choke" 	: loadResources("res://SFX/GatoProta/Choke/", 
								["1.mp3"]),
								"eating" 	: loadResources("res://SFX/GatoProta/Eating/", 
								["ñam1.mp3","ñam2.mp3","ñam3.mp3","ñam4.mp3","ñam5.mp3"]),
								"finish" 	: loadResources("res://SFX/GatoProta/Finished/", 
								["terminar1.mp3","terminar2.mp3","terminar3.mp3","terminar4.mp3","terminar5.mp3","terminar6.mp3"]),
							}
						},
			"winnerScreen" : { 	"anims" : "",
							"scale" : 1.0,
						},
		},
	"Miguel" : {
			"versusScreen" : "",
			"mainGame" : { 	"anims" : preload("res://RecursosGatos/Maingame_Miguel.tres"),
							"positionLeft" : [40,-402],
							"positionRight" : [40,-402],
							"scale" : Vector2(0.7, 0.7),
						},
			"winnerScreen" : { 	"anims" : "",
							"scale" : 1.0,
						},
		},
}

func loadResources(route : String , filenameList : Array):
	var resourcesArray = []
	for filename in filenameList:
		resourcesArray.append(load(route + filename))
	return resourcesArray
