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


## Returns last word in string
static func _get_last_word(from: String) -> String:
	var final_space_ix := from.rfind(' ')
	if final_space_ix == -1:
		return from
	
	return from.substr(final_space_ix)
