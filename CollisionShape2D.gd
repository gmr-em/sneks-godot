extends Area2D

export(PackedScene) var tailScene

var speed = 120
var rotationSpeed = PI/2
var direction = Vector2(0,-1)

var leftLimit = 200
var rightLimit = 800
var topLimit = 80
var bottomLimit = 480

var tail = []

func _ready():
	leftLimit = get_node("/root/root/Arena/Left").position.x
	rightLimit = get_node("/root/root/Arena/Right").position.x
	topLimit = get_node("/root/root/Arena/Top").position.y
	bottomLimit = get_node("/root/root/Arena/Bottom").position.y
	for i in range(4):
		var newTail = tailScene.instance()
		newTail.position = Vector2(self.position.x, self.position.y)
		newTail.get_node("CollisionShape2D").disabled = true
		get_node("..").call_deferred("add_child", newTail)
		tail.append(newTail)	
	

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.		
	if Input.is_key_pressed(KEY_RIGHT):
		direction = direction.rotated(-rotationSpeed * delta)
	if Input.is_key_pressed(KEY_LEFT):
		direction = direction.rotated(rotationSpeed * delta)
	
	var tailEnd = tail.pop_back()
	tailEnd.position = Vector2(self.position.x, self.position.y)
	tailEnd.get_node("CollisionShape2D").disabled = true
	tail.push_front(tailEnd)
	
	if tail.size() > 3 :
		var tail4 = tail[3]
		tail4.get_node("CollisionShape2D").disabled = false

	self.move_local_y(direction.x * speed * delta)
	self.move_local_x(direction.y * speed * delta)
	
	if self.position.x > rightLimit:
		self.position.x = leftLimit
	if self.position.x < leftLimit:
		self.position.x = rightLimit
	if self.position.y > bottomLimit:
		self.position.y = topLimit
	if self.position.y < topLimit:
		self.position.y = bottomLimit

#	if Input.is_key_pressed(KEY_UP):
#		self.move_local_y(-5)
#	if Input.is_key_pressed(KEY_DOWN):
#		self.move_local_y(5)


func _on_Area2D_area_entered(area):
	print ("Entered")
	#area.queue_free()