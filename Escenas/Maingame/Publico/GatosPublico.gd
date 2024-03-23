extends Node2D

# An array of different cat X positions
var catXPositions: Array = [ -10, 140, 290, 440, 590, 740, 890, 1040, 1190 ]
var end=false

# Array to store references to the instantiated cat instances
var catInstances: Array = []
@export var yippies : Array[AudioStream] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	if !Eventos.multiOnline:
		instantiateRandomCats()
	else:
		if !MultiplayerControl.isHost:
			ready_client.rpc()
	Eventos.catCheer.connect(triggerRandomCheer)
	Eventos.ganadorFestival.connect(triggerEnd)
	if (end):
		triggerRandomCheer(.9)

@rpc("any_peer","call_remote")
func ready_client():
	instantiateRandomCatsRpc.rpc(randi_range(6, 10) )

func triggerEnd(_ganador) ->void:
	end=true

func _process(_delta: float) -> void:
	# Check if the Enter key is pressed
	if Input.is_action_just_pressed("ui_accept"):
		# Call the triggerRandomCheer function
		triggerRandomCheer()

func instantiateRandomCats() -> void:
	# Generate a random number of cats
	var numberOfCats = randi_range(2+Eventos.cpuDiff, 10)

	# Shuffle the array of cat X positions to randomize their order
	catXPositions.shuffle()

	# Limit the number of cats to the size of the array
	numberOfCats = min(numberOfCats, catXPositions.size())

	for i in range(numberOfCats):
		# Instantiate the cat scene
		var catInstance = load("res://Escenas/Maingame/Publico/GatoPublico.tscn").instantiate()

		# Set the X position of the cat from the shuffled array
		catInstance.position.x = catXPositions[i]

		# Generate a random Y position within the range of -5 to 5 from a base Y position
		catInstance.position.y = randi_range(770, 780)
		var yipee = yippies.pick_random()
		catInstance.yipee = yipee
		# Add the cat to the scene
		add_child(catInstance)
		
		# Add the cat instance to the array
		catInstances.append(catInstance)

@rpc("authority","call_local","reliable")
func instantiateRandomCatsRpc(numberOfCats : int) -> void:
	# Generate a random number of cats

	# Shuffle the array of cat X positions to randomize their order
	catXPositions.shuffle()

	# Limit the number of cats to the size of the array
	numberOfCats = min(numberOfCats, catXPositions.size())

	for i in range(numberOfCats):
		# Instantiate the cat scene
		var catInstance = load("res://Escenas/Maingame/Publico/GatoPublico.tscn").instantiate()

		# Set the X position of the cat from the shuffled array
		catInstance.position.x = catXPositions[i]

		# Generate a random Y position within the range of -5 to 5 from a base Y position
		catInstance.position.y = randi_range(770, 780)
		var yipee = yippies.pick_random()
		catInstance.yipee = yipee
		# Add the cat to the scene
		add_child(catInstance)
		
		# Add the cat instance to the array
		catInstances.append(catInstance)

# Function to trigger a cheer animation randomly for some cats
func triggerRandomCheer(prob : float = 0.5) -> void:
	if Eventos.multiOnline:
		triggerRandomCheerRpc.rpc(prob)
	else:
		for cat in catInstances:
			# Generate a random number to determine if the cat cheers (50% chance)
			if randf() < prob:
				# Access the AnimationPlayer in each cat and play the cheer animation
				var animPlayer = cat.get_node("AnimationPlayer")
				if animPlayer != null:
					animPlayer.play("cheer")

@rpc("any_peer","unreliable","call_local")
func triggerRandomCheerRpc(prob : float = 0.5) -> void:
	for cat in catInstances:
		# Generate a random number to determine if the cat cheers (50% chance)
		if randf() < prob:
			# Access the AnimationPlayer in each cat and play the cheer animation
			var animPlayer = cat.get_node("AnimationPlayer")
			if animPlayer != null:
				animPlayer.play("cheer")
