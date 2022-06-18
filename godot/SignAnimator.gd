extends Node
class_name SignAnimator

signal finished

var figure: Spatial
var tween: Tween

func play(sign_sequence: Sign, initial_transition_time: float) -> void:
	assert(figure, "No figure set, nothing to which to apply animations.")
	assert(tween, "No tween set, cannot play animations without an assigned tween object.")
	# TODO: Setup initial position (tweening from current position if requested)
	# TODO: Setup tween interpolations for each movement
	print("animating... do be do...")
	tween.start()
	yield(tween, "tween_all_completed")
	emit_signal("finished")
