extends Node


var isHost : bool
var peer : WebRTCMultiplayerPeer
var address: String
var hostingId = 1
var clientId  
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Gotm.project_key = "authenticators/GFquHyGi6HGLvFE7FShM"
