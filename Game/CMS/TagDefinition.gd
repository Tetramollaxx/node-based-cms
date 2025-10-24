@abstract
extends Node
class_name Tag

## reference to the Entity's node
var node: Node
## reference to entity
var entity: Entity

@warning_ignore("unused_parameter")
func OnInit(): pass
func OnNodeReady(): pass
func OnNodeExitingTree(): pass
