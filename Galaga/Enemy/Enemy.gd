extends KinematicBody2D

export (int, "Bug", "Stone", "Spirit") var skin = 0
export var speed = 120
var fired = 0


var blue = Color(0.23, 0.91, 1)
var yellow = Color(0.91, 1, 0.27)
var red =  Color( 1, 0.23, 0.23)
var velocity = Vector2(10,0)
var health = 100

var trail = []
var magazine = []
var color = [yellow, blue, red]

onready var rate = get_node("Rate")
onready var sprite = get_node("Sprite")
onready var bullet = preload("res://Enemy/Enemy_Bullet.tscn")
onready var ammo = preload("res://Misc/Ammo.tscn")
onready var barrel = get_node("Barrel")
onready var player = get_tree().get_current_scene().get_node("Player")
onready var ring = get_node("Ring")
onready var anim = get_node("Ring_Fade")


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in sprite.get_children():
		trail.append(child)
		
	for line in trail:
		for child in line.get_children():
			child.get_child(0).visible = false
	
	ring.visible = false
	sprite.frame = skin
	sprite.scale = Vector2(1,1)
	modulate = color[skin]
#
#	match skin:
#		0: 
#			health = 120
#			$Rate.set_wait_time(0.9)
##			speed = 120
#		1:
#			health = 200
#			$Rate.set_wait_time(0.6)
##			speed = 80
#		2:
#			health = 250
#			$Rate.set_wait_time(0.2)
##			speed = 110
	
	for x in 25:
		var bullet_instance = bullet.instance()
		bullet_instance.get_child(0).disabled = true
		bullet_instance.visible =false
		bullet_instance.color = color[skin]
		bullet_instance.frame = skin
		get_tree().get_root().call_deferred("add_child",bullet_instance)
		magazine.append(bullet_instance)
	
		
	for line in trail[skin].get_children():
		line.get_child(0).visible = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	look_at(player.global_position)
	velocity = velocity.normalized()
	move_and_slide(velocity*speed)
	
	if health == 0:
		die()

#func fire():
#	fired += 1
#	CamShake.shake(1, 0.2)
#	var bullet_instance = bullet.instance()
#	get_tree().get_root().call_deferred("add_child",bullet_instance)
#	bullet_instance.color = color[skin]
#	bullet_instance.frame = skin
#	bullet_instance.global_position = barrel.global_position
#	var target = player.global_position
#	var direction_to_target = bullet_instance.global_position.direction_to(target).normalized()
#	bullet_instance.set_direction(direction_to_target)
#	bullet_instance.look_at(target)
#	print(fired)

func fire(instance):
	instance.start()
	instance.get_child(0).disabled = false
	instance.visible = true
	CamShake.shake(1, 0.2)
	instance.color = color[skin]
	instance.frame = skin
	instance.global_position = barrel.global_position
	var target = player.global_position
	var direction_to_target = instance.global_position.direction_to(target).normalized()
	instance.set_direction(direction_to_target)
	instance.look_at(target)
	


func die():
	$CollisionShape2D.disabled = true
	$Enemy_Area/CollisionShape2D.disabled = true
	CamShake.shake(1.1,0.2)
	$Splatter.emitting = true
	$Test.emitting = true
	$Rate.stop()
	anim.play("Fade")
	speed = 0
	health -= 10
	drop_ammo()
	yield(get_tree().create_timer(2),"timeout")
	
	queue_free()
	

func drop_ammo():
	var ammo_instance = ammo.instance()
	get_tree().get_root().call_deferred("add_child",ammo_instance)
	ammo_instance.modulate = color[skin]
	ammo_instance.get_child(1).frame = skin
	ammo_instance.global_position = global_position
	match ammo_instance.get_child(1).frame:
		0:
			ammo_instance.name = "Clip_1"
		1:
			ammo_instance.name = "Clip_2"
		2:
			ammo_instance.name = "Clip_3"

func _on_Rate_timeout():
	fire(magazine[fired])
	if fired < 24:
		fired += 1
	else:
		fired = 0
		fired += 1


func _on_Enemy_Area_area_entered(area):
	if "Bullet" in area.name:
		health -= 10
		anim.play("Blink")
	elif "Bomb" in area.name:
		health -= 25
		anim.play("Blink")
	
	if health <= 0:
		health = 0
	


func _on_Area2D_body_entered(body):
	if health > 0:
		if "Player" in body.name:
			$Rate.start(1.5)
