extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var anim = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_material().set_shader_param("offset", 2)

func _shake():
	CamShake.shake(1, 0.5)

func tween():
#	tween.interpolate_property(get_material(), "shader_param/Offset",1,100,5,Tween.TRANS_QUINT,Tween.EASE_OUT)
#	tween.start()
	anim.play("default")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
