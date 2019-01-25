extends Node

export(PackedScene) var food

var leftLimit = 200
var rightLimit = 800
var topLimit = 80
var bottomLimit = 480
var margin = 10

signal resetHead

func _ready():
	leftLimit = get_node("/root/root/Arena/Left").position.x + margin
	rightLimit = get_node("/root/root/Arena/Right").position.x - margin
	topLimit = get_node("/root/root/Arena/Top").position.y + margin
	bottomLimit = get_node("/root/root/Arena/Bottom").position.y - margin
	
	var FoodBasket = Node.new()
	FoodBasket.name = "FoodBasket"
	add_child(FoodBasket)
	
	var retry = get_node("gameOverPopup/Retry")
	retry.connect("pressed", self, "_on_Retry_pressed")
	
	var quit = get_node("gameOverPopup/Quit")
	quit.connect("pressed", self, "_on_Quit_pressed")
	
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var timer = Timer.new()
	timer.connect("timeout", self, "generateFood") 
	timer.wait_time = 4
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timer) #to process
	timer.start() #to start

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
	
func generateFood():
	var new_food = food.instance()
	new_food.position = Vector2(rand_range(rightLimit, leftLimit), rand_range(topLimit, bottomLimit))
	get_node("FoodBasket").add_child(new_food)
	

func _on_Retry_pressed():
	var basket = get_node("FoodBasket")
	
	for oldFood in basket.get_children():
		oldFood.queue_free()
	
#	get_node("Head").reset()
	emit_signal("resetHead")
	get_node("gameOverPopup").hide()
	get_tree().set_pause(false)
	
	
func dead():
	get_node("gameOverPopup").set_exclusive(true)
	get_node("gameOverPopup").popup()
	get_tree().set_pause(true)


func _on_Button_pressed():
	dead()

func _on_Quit_pressed():
	get_tree().set_pause(false)
	get_tree().change_scene("res://mainMenu.tscn")