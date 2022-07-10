extends Node

# Stores references to important nodes for global use (like attaching explosions, requesting paths nav maps, spawning entities, etc)

var node_references: Dictionary = {}

func find_node_references(root_node: Node):
	node_references = {}
	node_references['Effects'] = root_node.get_node('Effects')
	node_references['Entities'] = root_node.get_node('Entities')

func get(key: String) -> Node:
	return node_references.get(key)

func _exit_tree():
	node_references = {}
