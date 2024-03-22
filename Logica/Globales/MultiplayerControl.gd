extends Node


var isHost : bool
var address: String
var hostingId = 1
var clientId = null
var mp : MatchaRoom = null
signal new_event(args)

func create_server():
	mp = MatchaRoom.create_server_room()
	address = mp.id
	multiplayer.multiplayer_peer = mp
	mp.peer_joined.connect(new_peer)

func create_client():
	mp = MatchaRoom.create_client_room(address)
	multiplayer.multiplayer_peer = mp
	mp.peer_joined.connect(new_peer)

func new_event_handler(args):
	new_event.emit(args)

func new_peer(_id, peer):
	if clientId == null:
		clientId = peer._id
	var tt = "[Server] Peer joined (id=%s)\n and with id int =%s" % [peer.id,_id]
	print(tt)
	peer.emit_new_event.connect(new_event_handler)
