extends Node

@export var Captions: Label = null
@export var Loading: Node3D = null
@export var Eyes: MeshInstance3D = null
@export var I4Anim: AnimationPlayer = null
@export var SceneAnim: AnimationPlayer = null
var CaptionsTime: float = 0
var MaxCaptionsTime: float = 0
@export var Emotions: Dictionary = {
	0: Material,
	1: Material,
	4: Material
}
@export var NeutralEmotionMaterial: Material = null

func SetAutoData(value, obj: String):
	if (obj == "captions"):
		SetCaptions(value as String)
	elif (obj == "loading"):
		SetLoading(var_to_str(value).to_lower() == "true")
	elif (obj == "singing"):
		SetSinging(var_to_str(value).to_lower() == "true")
	elif (obj == "emotion"):
		SetEmotion(value as int);
	elif (obj == "read_chat"):
		ReadChat()

func SetCaptions(data: String):
	print("Set captions to '" + var_to_str(data) + "'")
	
	Captions.text = data
	CaptionsTime = 0
	MaxCaptionsTime = len(data) * 0.1;

func SetLoading(data: bool):
	print("Set loading to '" + var_to_str(data) + "'")
	Loading.visible = data

func SetSinging(data: bool):
	print("Set singing to '" + var_to_str(data) + "'")
	I4Anim.call("SetEnabled", not data)
	SceneAnim.call("SetEnabled", data)
	
	if (data):
		I4Anim.play("Singing")
	else:
		I4Anim.play_backwards("Singing")
		SceneAnim.play("RESET")

func ReadChat():
	print("Reading chat.")
	
	I4Anim.call("SetEnabled", false)
	I4Anim.play("Reading Chat")
	I4Anim.call("SetEnabled", true)

func SetEmotion(emotion: int):
	Eyes.material_override = Emotions.get(emotion, NeutralEmotionMaterial) as Material

func _process(delta):
	CaptionsTime += delta
	
	if (CaptionsTime >= MaxCaptionsTime):
		Captions.text = ""
		MaxCaptionsTime = -1
