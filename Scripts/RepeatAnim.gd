extends AnimationPlayer

@export var Anim: String = ""
@export var Enabled: bool = true

func SetEnabled(To: bool):
	Enabled = To

func _process(_delta):
	if (Enabled and current_animation == ""):
		current_animation = Anim
