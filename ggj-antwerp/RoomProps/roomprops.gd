extends Node2D
class_name RoomProps

enum States {
	DISABLED,
	ACTIVE
}
var active_sprite : Sprite2D
var disabled_sprite : Sprite2D
var active_clicking_collision : CollisionShape2D
var disabled_clicking_collision : CollisionShape2D

@export var clickable_area : Area2D
var current_state : States = States.DISABLED:
	set(value):
		if value == States.DISABLED:
			on_state_disabled()
		elif value == States.ACTIVE:
			on_state_active()
		current_state = value

func _ready():
	for child in get_children():
		if child is Sprite2D:
			if child.is_in_group("Active"):
				active_sprite = child
			elif child.is_in_group("Disabled"):
				disabled_sprite = child
		if child is Area2D:
			for collisionshape in child.get_children():
				if collisionshape.is_in_group("Active"):
					active_clicking_collision = collisionshape
				elif collisionshape.is_in_group("Disabled"):
					disabled_clicking_collision = collisionshape
	
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
	active_sprite.visible = false
	disabled_sprite.visible = true

func on_state_active():
	active_sprite.visible = true
	disabled_sprite.visible = false
