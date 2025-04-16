extends VideoStreamPlayer


func _ready() -> void:
	hide()


func sequence_play():
	show()
	play()
	await finished
