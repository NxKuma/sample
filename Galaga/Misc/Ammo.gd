extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Clip_1_area_entered(area):
	if "Player" in area.name:
		$Splatter.emitting = true
		$Sprite.visible = false
		yield(get_tree().create_timer(1),"timeout")
		queue_free()
