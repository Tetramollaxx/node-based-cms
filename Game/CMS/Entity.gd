extends Node
class_name Entity


var Tags : Array[Tag]
var node : Node


func Initialize(node_to_bind : Node):
	node = node_to_bind

	node.ready.connect(_on_node_ready)
	node.tree_exiting.connect(_on_node_exiting_tree)

	for t in get_children():
		t.node = node_to_bind
		t.entity = self
		t.OnInit()


func _on_node_exiting_tree():
	for t in Tags:
		t.OnNodeExitingTree()

func _on_node_ready():
	for t in Tags:
		t.OnNodeReady()


## Get tag by type/class
func GetTag(type : Variant):
	for t in Tags:
		if is_instance_of(t, type):
			return t
	return null

## Get tags by type/class
func GetTags(type : Variant):
	var to_return : Array[Tag]
	for t in Tags:
		if is_instance_of(t, type):
			to_return.append(t)
	return to_return