extends Tag
class_name TagRollValueOnPlay


@export var PossibleValues : Array[int] = [1,2,3,4,5,6]
@export var RolledValue : int = -1


func OnPlayedDice(dice : Dice):
	if dice == node:
		RolledValue = PossibleValues.pick_random()
		dice.value_label.text = str(RolledValue)
