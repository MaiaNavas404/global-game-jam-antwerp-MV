extends Node2D
class_name RoomProps

enum States {
	DISABLED,
	ACTIVE
}


@export var clickable_area : Area2D
var current_state : States = States.DISABLED:
	set(value):
		if value == States.DISABLED:
			on_state_disabled()
		elif value == States.ACTIVE:
			on_state_active()
		current_state = value

func _ready():
	clickable_area.input_event.connect(on_mouse_interact)
	current_state = States.DISABLED
	


func on_mouse_interact(viewport: Node, event: InputEvent, shape_idx: int):
	if event.is_pressed():
		cycle_current_state()
		


func cycle_current_state():
	current_state += 1
	if current_state >= len(States):
		current_state = 0

func on_state_disabled():
	pass

func on_state_active():
	pass
