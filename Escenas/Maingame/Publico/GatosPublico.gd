extends Node2D

# An array of different cat X positions
var catXPositions: Array = [ -10, 140, 290, 440, 590, 740, 890, 1040, 1190 ]

# Array to store references to the instantiated cat instances
var catInstances: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	instantiateRandomCats()
	Eventos.catCheer.connect(triggerRandomCheer)

func _process(delta: float) -> void:
	# Check if the Enter key is pressed
	if Input.is_action_just_pressed("ui_accept"):
		# Call the triggerRandomCheer function
		triggerRandomCheer()

func instantiateRandomCats() -> void:
	# Generate a random number of cats
	#TODO : dependiendo de la diff y todo menos o mas publico
	var numberOfCats = randi_range(6, 10)

	# Shuffle the array of cat X positions to randomize their order
	catXPositions.shuffle()

	# Limit the number of cats to the size of the array
	numberOfCats = min(numberOfCats, catXPositions.size())

	for i in range(numberOfCats):
		# Instantiate the cat scene
		var catInstance = preload("res://Escenas/Maingame/Publico/GatoPublico.tscn").instantiate()

		# Set the X position of the cat from the shuffled array
		catInstance.position.x = catXPositions[i]

		# Generate a random Y position within the range of -5 to 5 from a base Y position
		catInstance.position.y = randi_range(770, 780)

		# Add the cat to the scene
		add_child(catInstance)
		
		# Add the cat instance to the array
		catInstances.append(catInstance)

# Function to trigger a cheer animation randomly for some cats
func triggerRandomCheer(prob : float = 0.5) -> void:
	for cat in catInstances:
		# Generate a random number to determine if the cat cheers (50% chance)
		if randf() < prob:
			# Access the AnimationPlayer in each cat and play the cheer animation
			var animPlayer = cat.get_node("AnimationPlayer")
			if animPlayer != null:
				animPlayer.play("cheer")
