extends RoomProps
class_name HidableProps

@export var hiding_area : Area2D


var hidable := false:
	set(value):
		if value:
			clickable_area.z_index = 0
		else:
			clickable_area.z_index = 1
		hidable = value
func _ready():
	super._ready()
	#hiding_area.area_entered.connect(on_dead_body_entered)
	on_state_disabled()
	disabled_sprite.z_index = 1
	clickable_area.z_index = 1
func _physics_process(delta: float) -> void:
	if hidable:
		var dead_bodies = hiding_area.get_overlapping_bodies()
		for dead_body in dead_bodies:
			if dead_body.get_parent().overlapping_area_count >= dead_body.get_parent().total_area_count and !dead_body.get_parent().is_hidden:
				hide_dead_body(dead_body.get_parent())
				

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
	
	disabled_clicking_collision.disabled = state
	active_clicking_collision.disabled = !state

func hide_dead_body(body):
	for part in body.body_parts:
		part.freeze = true
	
	body.is_hidden = true
