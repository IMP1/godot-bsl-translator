extends Control

# I checked the terms are okay:
# https://www.reddit.com/r/BSL/comments/vf4don/comment/ictuypx/
enum Perspective { SPEAKER, LISTENER }

# TODO:
#   * Drag around to move camera
#   * Type into textbox to load signs
#   * Dropdown menu where multiple signs with same name

var perspective: int = Perspective.SPEAKER
var camera_moved: bool = false
var animator: SignAnimator = SignAnimator.new()

onready var figure: Spatial = $Viewport/World/Figure as Spatial
onready var tween: Tween = $Viewport/World/Tween as Tween
onready var camera_pivot: Spatial = $Viewport/World/CameraPivot as Spatial
onready var camera_dolly: Spatial = $Viewport/World/CameraPivot/CameraDolly as Spatial

func _ready():
	animator.figure = figure
	animator.tween = tween

func _toggle_perspective() -> void:
	if not camera_moved:
		perspective += 1
		perspective %= Perspective.size()
	match perspective:
		Perspective.SPEAKER:
			camera_pivot.translation = Vector3(0, 3, 0)
			camera_pivot.rotation_degrees = Vector3(-15, -180, 0)
			camera_dolly.translation.z = -1
		Perspective.LISTENER:
			camera_pivot.translation = Vector3(0, 2, 0)
			camera_pivot.rotation_degrees = Vector3(-15, 0, 0)
			camera_dolly.translation.z = 11
	camera_moved = false

func _on_search(text: String) -> void:
	print("Searching for '%s'..." % text)
	var results = {}
	results[text] = _find_signs(text)
	if results.empty() and text.count(" ") > 0:
		for word in text.split(" "):
			results[word] = _find_signs(word)
	print(results)
	if results.empty():
		# Sorry! No results! Can spell it out?
		pass
	# TODO: Think about what should happen here.
	#       If any signs have more than one possibility, offer the options to the user.
	# When all are chosen, then we move onto request_sign, I guess? 

func _find_signs(search_text: String) -> Array:
	# If there are matching signs for the whole phrase, return them
	# Otherwise return matches for 
	return []

func _request_sign(sign_phrase: String) -> void:
	sign_phrase = sign_phrase.strip_edges()
	if sign_phrase.count(" ") > 0:
		sign_phrase = translate_sign_phrase(sign_phrase)
	var signs := _create_sign_phrase(sign_phrase.split(" "))
	_play_signs(signs)

func translate_sign_phrase(sign_phrase: String) -> String:
	# TODO: Change grammar to fit BSL
	# TODO: Outsource this to hopefully existing software somewhere?
	return sign_phrase

func _create_sign_phrase(sign_words: Array) -> Sign:
	var composite_sign := Sign.new()
	if sign_words.empty():
		return composite_sign
	var first_sign : Sign = sign_words.pop_front()
	composite_sign.origin = first_sign.origin
	for movement in first_sign.movements:
		composite_sign.movements.append(movement)
	for following_sign in sign_words:
		composite_sign.movements.append(following_sign.origin)
		for movement in following_sign.movements:
			composite_sign.movements.append(movement)
	return composite_sign

func _play_signs(signs: Sign, initial_transition:float=0.0) -> void:
	animator.play(signs, initial_transition)

func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("camera_pan"):
		camera_moved = true
		camera_pivot.rotation_degrees.y -= event.relative.x
		camera_pivot.rotation_degrees.x -= event.relative.y
		camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, -60, 60)
	if event.is_action_pressed("camera_zoom_in"):
		camera_dolly.translation.z -= 0.5
		camera_moved = true
	if event.is_action_pressed("camera_zoom_out"):
		camera_dolly.translation.z += 0.5
		camera_moved = true
