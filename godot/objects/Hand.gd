tool
extends Spatial

export(Resource) var hand setget set_position_from_hand_state

func set_position_from_hand_state(hand_state: Resource) -> void:
	hand = hand_state as Hand
	if not hand:
		return
	if hand.side == Hand.Side.RIGHT:
		scale.x = -1
	else:
		scale.x = 1
