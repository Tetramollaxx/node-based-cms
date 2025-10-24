extends Node
## Lightweight version of Interactor, does not support Resource, but has better performance
class_name InteractionManagerLite

## Return all intraction that have method
func get_implementers(method_name: String) -> Array:
	var to_return: Array[Object]
	for i in get_tree().get_nodes_in_group("Interaction"):
		if i.has_method(method_name):
			to_return.append(i)
	return to_return

## Calls a method with the given name on all valid implementers, passing optional arguments
##
## For example: Interactions.call_implementers("OnBattleStart", turn_number)
##
## Would automatically invoke OnBattleStart(turn_number) on all nodes that have it and have group "Interaction"
func call_implementers(method_name: String, ...args: Array[Variant]):
	for i in get_implementers(method_name):
		i.callv(method_name, args)
