@tool
extends AnimationPlayer

@export var fps : float = 30.0

var _timer : float


func _ready():
	callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL


func _process(delta):
	_timer += delta
	var frame = 1.0/fps
	if _timer > frame:
		advance(_timer)
		_timer = fmod(_timer, frame)
