extends KinematicBody2D

var health = 1000
export(int, "Bug", "Stone", "Spirit") var skin = 0
export(String, "Hive", "Tesseract", "?????") var boss_name = "Hive"
onready var bars = get_tree().get_current_scene().get_node("Player/Camera2D/CanvasLayer/Health_Bars")
onready var cam = get_tree().get_current_scene().get_node("Player/Camera2D/Pan")
onready var cam_scale = get_tree().get_current_scene().get_node("Player/Camera2D")

var blue = Color(0.23, 0.91, 1)
var yellow = Color(0.91, 1, 0.27)
var red =  Color( 1, 0.23, 0.23)

var color = [yellow, blue, red]
var health_bar = []

# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	health_bar[skin].get_child(0).scale.x = health/1000.000
	
	
	if health == 0:
		die()


func die():
	if health > -55:
		cam.play("Zoom_in")
		$CollisionShape2D.disabled = true
		$Enemy_Base/CollisionShape2D.disabled = true
		health_bar[skin].visible = false
		CamShake.shake(1.1,0.2)
		$Splatter.emitting = true
		$Test.emitting = true
		$Ring_Fade.play("Fade")
		health -= 10
		
		print(health)
		set_physics_process(false)
		yield(get_tree().create_timer(2),"timeout")
		queue_free()

func _on_Area2D_area_entered(area):
	if health > 0:
		if "Bullet" in area.name:
			health -= 5
		elif "Bomb" in area.name:
			health -= 15
			
	if health <= 0:
		die()
	print(health)
	


func _on_Detect_area_entered(area):
	if health > 0:
		if "Player" in area.name:
			health_bar[skin].visible = true
			if cam_scale.scale != Vector2(2,2):
				cam.play("Pan_Out")


func _on_Exit_area_exited(area):
	if health > 0:
		if "Player" in area.name:
			health_bar[skin].visible = false
			cam.play("Zoom_in")
