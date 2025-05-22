class_name Utils
extends Resource


## Returns all recursive children of node that belong to groupName
static func find_node_descendants_in_group(node: Node, group_name: String) -> Array:
	var descendants_in_group := []
	for child in node.get_children():
		if child.is_in_group(group_name):
			descendants_in_group.append(child)
		descendants_in_group += find_node_descendants_in_group(child, group_name)
	return descendants_in_group


## Returns all recursive children of node that belong of type type
static func find_node_descendants_of_type(node: Node, type) -> Array:
	var descendants_in_group := []
	for child in node.get_children():
		if is_instance_of(child, type):
			descendants_in_group.append(child)
		descendants_in_group += find_node_descendants_of_type(child, type)
	return descendants_in_group


## Returns first ancestor of type type
static func find_ancestor_of_type(node: Node, type) -> Node:
	if node.get_parent() == null or is_instance_of(node.get_parent(), type):
		return node.get_parent()
	
	return find_ancestor_of_type(node.get_parent(), type)
static func find_node_by_name_in_array(name: String, array: Array[Node]) -> Node:
	for element in array:
		if element.name == name:
			return element
	
	return null


static func floor_step(value: float, step: float) -> float:
	return value - fposmod(value, step)


static func floor_step_v2(value: Vector2, step: Vector2) -> Vector2:
	return Vector2(floor_step(value.x, step.x), floor_step(value.y, step.y))


static func floor_step_v3(value: Vector3, step: Vector3) -> Vector3:
	return Vector3(floor_step(value.x, step.x), floor_step(value.y, step.y), floor_step(value.z, step.z))


static func cast_raycast(space: PhysicsDirectSpaceState3D, from: Vector3, to: Vector3, collide_bodies: bool = true, collide_areas: bool = false, mask: int = 0xFFFFFFFF) -> Dictionary:
	var parameters := PhysicsRayQueryParameters3D.new()
	parameters.from = from
	parameters.to = to
	parameters.collide_with_bodies = collide_bodies
	parameters.collide_with_areas = collide_areas
	parameters.collision_mask = mask
	return space.intersect_ray(parameters)


static func get_top_node_at_point(direct_space_state: PhysicsDirectSpaceState2D, point: Vector2) -> CollisionObject2D:
	var minNode = null
	var query := PhysicsPointQueryParameters2D.new()
	query.position = point
	query.collide_with_areas = true
	var intersects = direct_space_state.intersect_point(query)
	
	for i in intersects:
		if minNode == null or i["collider"].is_greater_than(minNode):
			minNode = i["collider"] # Filter lowest node in tree
	return minNode


static func remove_all_children(from: Node):
	for child in from.get_children():
		child.queue_free()
