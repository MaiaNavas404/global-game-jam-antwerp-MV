extends RoomProps
class_name HidableProps

@export var hiding_area : Area2D
@export var closed_sprite : Sprite2D
@export var open_sprite : Sprite2D

var hidable := false

func _ready():
	super._ready()
	on_state_disabled()

func on_state_disabled():
	super.on_state_disabled()
	hidable = false
	set_hiding_area_active(false)
	set_sprite_active(false)

func on_state_active():
	super.on_state_active()
	hidable = true
	set_hiding_area_active(true)
	set_sprite_active(true)

func set_hiding_area_active(state : bool):
	hiding_area.monitoring = state
	hiding_area.monitorable = state

func set_sprite_active(state : bool):
	open_sprite.visible = state
	closed_sprite.visible = !state
