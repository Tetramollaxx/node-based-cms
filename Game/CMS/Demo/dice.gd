extends Node2D
class_name Dice


@export var entity : PackedScene
@onready var value_label: Label = $ValueLabel

func _enter_tree() -> void:
    CMS.create_entity(self, entity)