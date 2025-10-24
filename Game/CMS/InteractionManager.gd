extends Node
## Manages a global list of all nodes and resources that have interaction behavior. Autoload "Interactions"
## 
## Scans the entire scene tree and all attached resources to find anything with the
## metadata key "Interaction" == true. Then allows global signaling based on method names.
##
## This enables decentralized "event bus"-style logic without signals or subscriptions.
class_name InteractionManager

## Maximum refs before cleanup
var ClearThreshold: int = 5

## Stores all objects (nodes or resources) that declared themselves as interactive
var _interactions: Array[WeakRef] = []
var _visited : = {}

## Enable debug output
var debug_print: bool = false

func _ready() -> void:
	_initialize_interactions()
	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_deleted)

func _on_node_added(n: Node):
	if n.has_meta("Interaction") and n.get_meta("Interaction"):
		if !_has(n):
			_interactions.append(weakref(n))
	var props := n.get_property_list()
	for p in props:
		var value = n.get(p.name)
		_process_prop(value)

func _on_node_deleted(n: Node):
	if _has(n):
		for i in _interactions.size():
			if _interactions[i].get_ref() == n:
				_interactions.remove_at(i)
	if _interactions.size() > ClearThreshold:
		for i in range(_interactions.size() - 1, -1, -1):
			var ref = _interactions[i]
			if ref == null or !is_instance_valid(ref.get_ref()) or ref.get_ref() == null:
				_interactions.remove_at(i)
		_visited.clear()

func _initialize_interactions():
	var root = get_tree().root
	for c in root.get_children():
		_process_node_recursive(c)
	if debug_print:
		for i in _interactions:
			print("Registered interaction: ", i.get_ref())

func _process_node_recursive(n: Node):
	if _was_visited(n):
		return
	_mark_visited(n)
	if n.has_meta("Interaction") and n.get_meta("Interaction"):
		if !_has(n):
			_interactions.append(weakref(n))
	for c in n.get_children():
		_process_node_recursive(c)
	var props := n.get_property_list()
	for p in props:
		var value = n.get(p.name)
		_process_prop(value)

func _process_prop(value):
	if value == null or _was_visited(value):
		return
	_mark_visited(value)
	if typeof(value) == TYPE_ARRAY:
		for i in value:
			_process_prop(i)
	elif typeof(value) == TYPE_DICTIONARY:
		for k in value:
			_process_prop(value[k])
	elif typeof(value) == TYPE_OBJECT:
		if value.has_meta("Interaction") and value.get_meta("Interaction"):
			if !_has(value):
				_interactions.append(weakref(value))
		for p in value.get_property_list():
			var v = value.get(p.name)
			if typeof(v) == typeof(value) and v == value:
				continue
			_process_prop(v)

func _has(obj: Object) -> bool:
	for i in _interactions:
		if i.get_ref() == obj:
			return true
	return false

func _was_visited(obj):
	if not obj is Object:
		return false
	return _visited.has(obj.get_instance_id())

func _mark_visited(obj):
	if not obj is Object:
		return
	_visited[obj.get_instance_id()] = true

## Returns a list of all live objects (nodes/resources) that:
##
## Are marked with "Interaction" metadata
##
## Implement the method method_name
##
## This is useful for checking who is interested in a given "event"
func get_implementers(method_name: String) -> Array:
	var to_return: Array[Object]
	for i in range(_interactions.size() - 1, -1, -1):
		var ref = _interactions[i]
		if ref == null or !is_instance_valid(ref.get_ref()) or ref.get_ref() == null:
			_interactions.remove_at(i)
			continue
		var obj = ref.get_ref()
		if obj.has_method(method_name):
			to_return.append(obj)
	_visited.clear()
	if debug_print:
		print("Interactions count: ", _interactions.size())
	return to_return

## Calls a method with the given name on all valid implementers, passing optional arguments
##
## For example: Interactions.call_implementers("OnBattleStart", turn_number)
##
## Would automatically invoke OnBattleStart(turn_number) on all registered objects that have it
func call_implementers(method_name: String, ...args: Array[Variant]):
	for i in get_implementers(method_name):
		i.callv(method_name, args)
