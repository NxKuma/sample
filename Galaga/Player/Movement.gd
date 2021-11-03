extends KinematicBody2D

export var speed = 120
var health = 100

var gun_clip_1 = 30
var gun_clip_2 = 150
var gun_clip_3 = 100
var bullet_line = 0

var magazine = [gun_clip_1, gun_clip_2, gun_clip_3]
var bullet_pool = []


onready var sprite = get_node("Ship")
onready var barrel = get_node("Barrel")
onready var bullet_range = get_node("Ship/Attachments/Bullet_Range")
onready var muzzle = get_node("Barrel/Particles2D")
onready var laser = get_node("Barrel/Laser")
onready var bullet_fired = 0
onready var swap_int = 0

var blue = Color(0.23, 0.91, 1)
var blue_cross = load("res://PNG/CrossHair-export1.png")

var yellow = Color(0.91, 1, 0.27)
var yellow_cross = load("res://PNG/CrossHair-export2.png")

var red =  Color( 1, 0.23, 0.23)
var red_cross = load("res://PNG/CrossHair-export3.png")

var color = [blue, yellow, red]
var crosshair = [blue_cross, yellow_cross, red_cross]
var color_int = 0
var click_pos
var mag_hold = []

onready var tween = get_node("3D Tween")
onready var swap_rate = get_node("Swap")
onready var fire_rate = get_node("Rate")
onready var rect  = get_node("Camera2D/CanvasLayer/ColorRect")
onready var bullet = preload("res://Player/Bullet.tscn")
onready var magazine_holder = get_node("Camera2D/CanvasLayer/Clips")
onready var health_holder = get_node("Camera2D/CanvasLayer/Health")

#Movement
var input_vector = Vector2.ZERO
var FRICTION = 245
var ACCELERATION = 290
var MAX_SPEED = 300
var velocity = Vector2.ZERO

func _ready():
	var count = 0
	for child in magazine_holder.get_children():
		mag_hold.append(child)
		child.modulate = color[count]
		child.get_child(0).frame = count
		count+=1
		
	for x in 50:
		var bullet_instance = bullet.instance()
		bullet_instance.visible =false
		get_tree().get_root().call_deferred("add_child",bullet_instance)
		bullet_pool.append(bullet_instance)
	
	laser.visible = false

	

func _input(event):
	if Input.is_action_just_pressed("swap") and swap_int == 0:
		laser.visible = false
		color_int += 1
		rect.tween()
		tween.start()
		swap_int += 1
		swap_rate.start(0.8)
		
		if color_int > 2:
			color_int = 0
	
	if Input.is_action_just_pressed("Boost"):
		rect.tween()
		tween.start()
		speed = 550
	if Input.is_action_just_released("Boost"):
		speed = 250
	
	if color_int == 2:
		if magazine[color_int] > 0:
			if Input.is_action_pressed("shoot"):
				CamShake.shake(0.5, 0.2)
				laser.visible = true
				laser.set_is_casting(true)
			elif Input.is_action_just_released("shoot"):
				laser.set_is_casting(false)
		else:
			laser.visible = false
	elif color_int == 0:
		if Input.is_action_just_pressed("shoot") and bullet_fired == 0:
			fire(bullet_pool[bullet_line])
			fire_rate.start(0.7)
			if bullet_line < 49:
				bullet_line += 1
			else:
				bullet_line = 0
				bullet_line += 1
	else:
		if Input.is_action_pressed("shoot") and bullet_fired == 0:
			fire(bullet_pool[bullet_line])
			fire_rate.start(0.1)
			if bullet_line < 49:
				bullet_line += 1
			else:
				bullet_line = 0
				bullet_line += 1


func _physics_process(delta):
	look_at(get_global_mouse_position())
	click_pos = get_local_mouse_position()
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		velocity.y = -1
	if Input.is_action_pressed("ui_down"):
		velocity.y = 1
	if Input.is_action_pressed("ui_right"):
		velocity.x = 1
	if Input.is_action_pressed("ui_left"):
		velocity.x = -1
	
	velocity = velocity.normalized()
	move_and_slide(velocity * speed)
	
	sprite.modulate = color[color_int]
	if crosshair != null:
		Input.set_custom_mouse_cursor(crosshair[color_int])
	
	for clip in magazine_holder.get_children():
		clip.get_child(1) 
	
	health_holder.get_child(1).text = String(health)
	
	for x in 3:
		if x == color_int:
			mag_hold[x].scale = Vector2(1,1)
			mag_hold[x].position = Vector2(-8,mag_hold[x].position.y)
		else:
			mag_hold[x].scale = Vector2(0.7,0.7)
			mag_hold[x].position = Vector2(0,mag_hold[x].position.y)
			
		mag_hold[x].get_child(1).text = String(magazine[x])

#func fire():
#	if magazine[color_int] >= 1:
#		bullet_fired += 1
#		magazine[color_int] -= 1
#		CamShake.shake(1, 0.2)
#		var bullet_instance = bullet.instance()
#		get_tree().get_root().call_deferred("add_child",bullet_instance)	
#		bullet_instance.look_at(get_global_mouse_position())
#		bullet_instance.color = color[color_int]
#		bullet_instance.frame = color_int
#		bullet_instance.global_position = barrel.global_position
#		var target = get_global_mouse_position()
#		var direction_to_target = bullet_instance.global_position.direction_to(target).normalized()
#		bullet_instance.set_direction(direction_to_target)
		
func fire(instance):
	if magazine[color_int] >= 1:
		bullet_fired += 1
		magazine[color_int] -= 1
		CamShake.shake(1, 0.2)
		instance.modulate = color[color_int]
		instance.sprite.frame = color_int
		instance.global_position = barrel.global_position
		var target = get_global_mouse_position()
		var direction_to_target = instance.global_position.direction_to(target).normalized()
		instance.set_direction(direction_to_target)
		
		if instance.death == true:
			instance.death = false
		instance.start()
		print(bullet_line)


func _on_Rate_timeout():
	bullet_fired = 0


func _on_Swap_timeout():
	swap_int = 0


func _on_Player_Area_area_entered(area):
	if "Enem_Dmg" in area.name:
		health -= 10
	
	if "Clip_1" in area.name:
		magazine[1] += 25
	elif "Clip_2" in area.name:
		magazine[0] += 8
	elif "Clip_3" in area.name:
		magazine[2] += 75


