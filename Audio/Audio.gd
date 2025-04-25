@icon("res://Audio/Audio.svg")
class_name Audio
extends Node


static func instantiate() -> Audio:
	return load("res://Audio/Audio.tscn").instantiate()
