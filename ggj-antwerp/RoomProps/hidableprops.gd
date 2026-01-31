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
	disabled_sprite.z_index = 1
	#hiding_area.area_entered.connect(on_dead_body_entered)
	on_state_disabled()

func _physics_process(delta: float) -> void:
	if hidable:
		var dead_bodies = hiding_area.get_overlapping_bodies()
		for dead_body in dead_bodies:
			if dead_body.overlapping_area_count >= dead_body.total_area_count and !dead_body.is_hidden:
				hide_dead_body(dead_body)
				

func on_state_disabled():
	super.on_state_disabled()
	set_object_state_active(false)

func on_state_active():
	super.on_state_active()
	set_object_state_active(true)

func set_object_state_active(state : bool):
	hidable = state
	#hiding_area.monitoring = state
	#hiding_area.monitorable = state
	active_sprite.visible = state
	disabled_sprite.visible = !state
	disabled_clicking_collision.disabled = state
	active_clicking_collision.disabled = !state

func hide_dead_body(body : RigidBody2D):
	body.freeze = true
	body.is_hidden = true
