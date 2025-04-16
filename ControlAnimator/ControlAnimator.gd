## Autoload ControlAnimator
extends Control


const META_PHANTOM := "ControlAnimator_Phantom"


## Animates a target node from their current parent to a new_parent
func change_parentage(target: Control, new_parent: Container):
	const DURATION := 0.4
	
	var size_calc := await create_size_calc(target, new_parent)
	
	var destination_phantom := Control.new()
	new_parent.add_child(destination_phantom)
	
	var target_phantom := create_placeholder_phantom(target)
	
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	tween.tween_property(target, "global_position", size_calc.global_position, DURATION)
	tween.tween_property(target, "size", size_calc.size, DURATION)
	tween.tween_property(target_phantom, "custom_minimum_size", Vector2.ZERO, DURATION)
	tween.tween_property(destination_phantom, "custom_minimum_size", size_calc.size, DURATION)
	register_tween(target, tween)
	register_tween(target_phantom, tween)
	register_tween(destination_phantom, tween)
	tween.play()
	
	await tween.finished
	remove_child(target)
	destination_phantom.replace_by(target)
	destination_phantom.queue_free()
	target_phantom.queue_free()


func create_placeholder_phantom(target: Control) -> Control:
	var phantom := Control.new()
	phantom.custom_minimum_size = target.size
	
	var target_global_pos := target.global_position
	target.set_meta(META_PHANTOM, phantom)
	target.replace_by(phantom)
	self.add_child(target)
	target.global_position = target_global_pos
	
	return phantom


func return_to_phantom(target: Control, duration: float):
	var source_phantom: Control = target.get_meta(META_PHANTOM)
	
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	tween.tween_property(target, "global_position", source_phantom.global_position, duration)
	tween.tween_property(target, "rotation", source_phantom.rotation, duration)
	tween.tween_property(target, "scale", source_phantom.scale, duration)
	tween.play()
	register_tween(target, tween)
	
	await tween.finished
	source_phantom.replace_by(target)
	target.remove_meta(META_PHANTOM)
	source_phantom.queue_free()


## Creates a Control node sized with *source*'s sizing settings in *on* node.
## The returned node remains as a child of ControlAnimator
func create_size_calc(source: Control, on: Control) -> Control:
	var size_calc := Control.new()
	size_calc.custom_minimum_size = source.custom_minimum_size
	size_calc.size_flags_horizontal = source.size_flags_horizontal
	size_calc.size_flags_vertical = source.size_flags_vertical
	size_calc.size_flags_stretch_ratio = source.size_flags_stretch_ratio
	on.add_child(size_calc)
	on.queue_sort()
	await on.sort_children
	size_calc.reparent(self, true)
	on.queue_sort()
	
	return size_calc


func register_tween(at: Node, tween: Tween) -> void:
	if at.has_meta(Metadata.ACTIVE_TWEEN):
		unregister_tween(at) # Abort current animation if it exists
	
	at.set_meta(Metadata.ACTIVE_TWEEN, tween)
	tween.finished.connect(unregister_tween.bind(at))


func unregister_tween(at: Node) -> void:
	if at.has_meta(Metadata.ACTIVE_TWEEN):
		var tween: Tween = at.get_meta(Metadata.ACTIVE_TWEEN)
		if tween:
			tween.kill()
		
		at.remove_meta(Metadata.ACTIVE_TWEEN)


func apply_animation(to: Control, pos_offset: Vector2, rot_offset: float, scale_offset: Vector2, duration: float):
	create_placeholder_phantom(to)
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	tween.tween_property(to, "position", pos_offset, duration)
	tween.tween_property(to, "rotation", rot_offset, duration)
	tween.tween_property(to, "scale", scale_offset, duration)
	register_tween(to, tween)


func remove_animation(to: Control, duration: float):
	unregister_tween(to) # If tween active, abort and delete
	
	return_to_phantom(to, duration)
