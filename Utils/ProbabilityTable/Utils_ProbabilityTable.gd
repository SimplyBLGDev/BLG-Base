class_name Utils_ProbabilityTable
extends Resource

@export var entries: Array[Utils_ProbabilityTable_Entry] = []

var rng := RandomNumberGenerator.new()

func choose_item(exclude: Array[Resource]) -> Resource:
	var total_weight := 0.0
	
	for entry in entries:
		if entry.result in exclude:
			continue
		
		total_weight += entry.weight
	
	var r := rng.randf_range(0.0, total_weight)
	
	for entry in entries:
		if entry.result in exclude:
			continue
		
		r -= entry.weight
		if r <= 0.0:
			return entry.result
	
	return null
