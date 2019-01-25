extends Area2D

export(PackedScene) var tailScene
export var player = 0

var speed = 120
var rotationSpeed = PI/1.1
var direction = Vector2(0,-1)

var leftLimit = 200
var rightLimit = 800
var topLimit = 80
var bottomLimit = 480

var waitTime = 0.1
var ate = false

var tail = []

var moveRightPressed = false
var moveLeftPressed = false
var some = ""

var RIGHT = KEY_RIGHT
var LEFT = KEY_LEFT

func _ready():
	leftLimit = get_node("/root/root/Arena/Left").position.x
	rightLimit = get_node("/root/root/Arena/Right").position.x
	topLimit = get_node("/root/root/Arena/Top").position.y
	bottomLimit = get_node("/root/root/Arena/Bottom").position.y
	
	get_parent().connect("resetHead", self, "_on_reset")
	reset()
	
	if (player == 2):
		RIGHT = KEY_D
		LEFT = KEY_A
	
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var timer = Timer.new()
	timer.connect("timeout", self, "moveSnek") 
	timer.wait_time = waitTime
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(timer) #to process
	timer.start() #to start

func moveSnek():
	var delta = waitTime	
	# Called every frame. Delta is time since last frame.
	# Update game logic here.		
	if Input.is_key_pressed(RIGHT) or moveRightPressed:
		direction = direction.rotated(-rotationSpeed * delta)
	if Input.is_key_pressed(LEFT) or moveLeftPressed:
		direction = direction.rotated(rotationSpeed * delta)
	
	# if we just ate then create a new tail object in the current position of the head (head will move later)
	if ate:
		ate = false
		var newTail = tailScene.instance()
		newTail.get_node("CollisionShape2D").disabled = true
		newTail.position = Vector2(self.position.x, self.position.y)		
		get_node("..").call_deferred("add_child", newTail)
		tail.push_front(newTail)
		# also increment the score
		incrementScore()
		
	else: # if we didn't eat then take the last tail piece and move it to the current pos of the head (head will move later)
		var tailEnd = tail.pop_back()
		tailEnd.get_node("CollisionShape2D").disabled = true
		tailEnd.position = Vector2(self.position.x, self.position.y)		
		tail.push_front(tailEnd)	

	# move head in the forward direction
	self.move_local_y(direction.x * speed * delta)
	self.move_local_x(direction.y * speed * delta)
	
	if tail.size() > 3 :
		var tail4 = tail[3]
		tail4.get_node("CollisionShape2D").disabled = false
	
	if self.position.x > rightLimit:
		self.position.x = leftLimit
	if self.position.x < leftLimit:
		self.position.x = rightLimit
	if self.position.y > bottomLimit:
		self.position.y = topLimit
	if self.position.y < topLimit:
		self.position.y = bottomLimit

func _on_Area2D_area_entered(area):
	if (area.get_parent().get_name() == "FoodBasket"):
		area.queue_free() 
		ate = true
	else:
		get_parent().dead()
		

func _on_MoveRight_button_up():
	moveRightPressed = false
	pass # replace with function body

func _on_MoveRight_button_down():
	moveRightPressed = true
	pass # replace with function body

func _on_MoveLeft_button_down():
	moveLeftPressed = true
	pass # replace with function body

func _on_MoveLeft_button_up():
	moveLeftPressed = false
	pass # replace with function body

func incrementScore():
	var score = get_node("/root/root/UI"+String(player)+"/Score")
	score.text = "Score: " + (String (tail.size() - 3))
	
func _on_reset():
	reset()
	
func reset():
	ate = false
	for tailPiece in tail:
		tailPiece.queue_free()
	tail.clear()
	
	
	self.position.y = 300
	if (player == 0):
		self.position.x = 500		
	else:
		self.position.x = 300 * player^2
	self.direction.x = -1
	self.direction.y = 0
	
	for i in range(3):
		var newTail = tailScene.instance()
		newTail.position = Vector2(self.position.x, self.position.y)
		newTail.get_node("CollisionShape2D").disabled = true
		get_node("..").call_deferred("add_child", newTail)
		tail.append(newTail)
