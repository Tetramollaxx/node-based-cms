@abstract
extends Node
class_name Tag

## reference to the Entity's node
var node: Node
## reference to entity
var entity: Entity

# virtual
func OnInit(): pass
func OnNodeReady(): pass
func OnNodeExitingTree(): pass
