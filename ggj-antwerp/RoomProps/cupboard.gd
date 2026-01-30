extends RoomProps
class_name HidableProps

@export var hiding_area : Area2D

var hidable := false

func on_state_disabled():
	super.on_state_disabled()
	hidable = false
	set_hiding_area_active(false)

func on_state_active():
	super.on_state_active()
	hidable = true
	set_hiding_area_active(true)

func set_hiding_area_active(state : bool):
	hiding_area.monitoring = state
	hiding_area.monitorable = state
