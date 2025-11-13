extends Tag
class_name TagRollValueOnPlay


@export var PossibleValues : Array[int] = [1,2,3,4,5,6]
@export var RolledValue : int = -1


func OnPlayedDice():
	RolledValue = PossibleValues.pick_random()
	await node.VFXJump()
	node.value_label.text = str(RolledValue)
