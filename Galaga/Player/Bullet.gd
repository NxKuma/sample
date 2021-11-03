extends Area2D

var speed = 10
var direction = Vector2.ZERO
var movement = Vector2()
var color
var frame
var death = false

onready var smoke = get_node("Big")
onready var smol_smoke = get_node("Small")
onready var sprite = get_node("Sprite")
onready var bomb = get_node("Bomb")
onready var gun = get_node("MachineGun")
onready var timer = get_node("Timer")

func _physics_process(delta):
	if direction != Vector2.ZERO:
		movement = direction * speed
		global_position += movement
	
func set_direction(direction: Vector2):
	self.direction = direction

func start():
	visible = true
	look_at(get_global_mouse_position())
	
	if sprite.frame == 0:
		name = "Bomb"
		speed = 13
		bomb.disabled = false
		gun.disabled = true
		$Timer.start(0.8)
	else:
		name = "Bullet"
		speed = 10
		gun.disabled = false
		bomb.disabled = true
		$Timer.start(0.5)
		

func die(emmit: bool):
	death = true
	CamShake.shake(2, 0.1)
	speed = 0
	if frame == 0:
#		smoke.emitting = emmit
		bomb.disabled = true
	else:
#		smol_smoke.emitting = emmit
		gun.disabled = true
	visible = false

func _on_Timer_timeout():
	if !death:
		die(true)	


func _on_Area_area_entered(area):
	if "Enemy" in area.name:
		$Timer.stop()
		die(true)
