extends Node2D
class_name Dice


@export var entity : PackedScene
@onready var value_label: Label = $ValueLabel

func _enter_tree() -> void:
	CMS.create_entity(self, entity)


func VFXJump():
	var t : Tween = get_tree().create_tween()
	
	t.tween_property(self, "scale", 1.1 * Vector2.ONE, 0.15)
	
	await t.finished
	
	t = get_tree().create_tween()
	t.tween_property(self, "scale", Vector2.ONE, 0.15)
	
	await t.finished
