extends RayCast2D

var is_casting = false setget set_is_casting
onready var particle = get_parent().get_parent().get_node("Test")
onready var player = get_parent().get_parent()


func _ready():
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventMouseButton:
		self.is_casting = event.pressed

func _physics_process(delta):
	var cast_point = cast_to
	force_raycast_update()
	
	$CollisionParticle.emitting = is_colliding()
	if visible:
		if is_colliding():
			var object_collided_with = get_collider()
			
			player.magazine[2] -= 1
			if "Enemy" in object_collided_with.name:
				object_collided_with.health -= 2
				object_collided_with.anim.play("Blink")
			if "Boss" in object_collided_with.name:
				object_collided_with.health -= 2
			
			cast_point = to_local(get_collision_point())
			$CollisionParticle.global_rotation = get_collision_normal().angle()
			$CollisionParticle.position = cast_point
			particle.lifetime = 0.2
			particle.position = $CollisionParticle.position
			particle.restart()
			
			if player.magazine[2] < 0:
				player.magazine[2] = 0
			
		
		
		
	$Line2D.points[1] = cast_point
	$BeamParticle.position = cast_point * 0.5
	$BeamParticle.process_material.emission_box_extents.x = cast_point.length() *0.5

func set_is_casting(cast: bool):
	is_casting = cast
	
	$BeamParticle.emitting = is_casting
	$CastingParticle.emitting = is_casting
	if is_casting:
		appear()
	else:
		$CollisionParticle.emitting = false
		disappear()
	
	set_physics_process(is_casting)
	
func appear():
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D,"width", 0, 10.0, 0.2)
	$Tween.start()
	
func disappear():
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D,"width", 10.0, 0, 0.1)
	$Tween.start()
