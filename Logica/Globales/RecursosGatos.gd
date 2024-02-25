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
								"stunned" 	: Globals.loadResources("res://SFX/Gatos/Timmy/Stunned/"),
								"choke" 	: Globals.loadResources("res://SFX/Gatos/Timmy/Choke/"),
								"eating" 	: Globals.loadResources("res://SFX/Gatos/Timmy/Eating/"),
								"finished" 	: Globals.loadResources("res://SFX/Gatos/Timmy/Finished/"),
							},
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
							"sonidos" : {
								"stunned" 	: Globals.loadResources("res://SFX/Gatos/Miguel/Stunned/"),
								"choke" 	: Globals.loadResources("res://SFX/Gatos/Miguel/Choke/"),
								"eating" 	: Globals.loadResources("res://SFX/Gatos/Miguel/Eating/"),
								"finished" 	: Globals.loadResources("res://SFX/Gatos/Miguel/Finished/"),
							},
						},
			"winnerScreen" : { 	"anims" : "",
							"scale" : 1.0,
						},
		},
}

