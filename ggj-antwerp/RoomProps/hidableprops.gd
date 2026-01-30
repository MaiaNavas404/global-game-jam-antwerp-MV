extends RoomProps
class_name HidableProps

@export var hiding_area : Area2D
var active_sprite : Sprite2D
var disabled_sprite : Sprite2D
var active_clicking_collision : CollisionShape2D
var disabled_clicking_collision : CollisionShape2D
var hidable := false

func _ready():
	
	for child in get_children():
		if child is Sprite2D:
			if child.is_in_group("Active"):
				active_sprite = child
			elif child.is_in_group("Disabled"):
				disabled_sprite = child
		elif child is Area2D:
			for collisionshape in child.get_children():
				if collisionshape.is_in_group("Active"):
					active_clicking_collision = collisionshape
				elif collisionshape.is_in_group("Disabled"):
					disabled_clicking_collision = collisionshape
	super._ready()
	hiding_area.area_entered.connect(on_dead_body_entered)
	on_state_disabled()
	

func on_state_disabled():
	super.on_state_disabled()
	set_object_state_active(false)
	
func on_state_active():
	super.on_state_active()
	set_object_state_active(true)

func set_object_state_active(state : bool):
	hidable = state
	hiding_area.monitoring = state
	hiding_area.monitorable = state
	active_sprite.visible = state
	disabled_sprite.visible = !state
	disabled_clicking_collision.disabled = state
	active_clicking_collision.disabled = !state

func on_dead_body_entered(area : Area2D):
	if hidable:
		print("HIDE THE BODY")
