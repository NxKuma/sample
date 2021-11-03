extends Area2D

var color
var frame
var target
var speed = 1
var direction = Vector2.ZERO
var movement = Vector2()

onready var sprite = get_node("Sprite")
onready var sharp = get_node("Sharp")
onready var blunt = get_node("Bullet")

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.modulate = color
	sprite.frame = frame
	
	if frame == 0:
		blunt.visible = false
		blunt.disabled = true
		sprite.rotation = 44.8
	else:
		sharp.visible = false
		sharp.disabled = true
		sprite.rotation = 90
		
func _physics_process(delta):
	if direction != Vector2.ZERO:
		movement = direction * speed
		global_position += movement
	
func set_direction(direction: Vector2):
	self.direction = direction
	

func start():
	match frame:
		0:
			speed = 12
			$Timer.start(2)
		1:
			speed = 8
			$Timer.start(1.5)
		2:
			speed = 7
			$Timer.start(1.4)

func die():
	speed = 0
	visible = false
	if frame == 0:
		blunt.disabled = true
		sharp.disabled = true
	else:
		blunt.disabled = true
		sharp.disabled = true
	

func _on_Timer_timeout():
	die()


func _on_Enemy_Bullet_area_entered(area):
	if area.name == "Player_Area":
		die()
