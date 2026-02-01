extends RoomProps

func on_state_active():
	super.on_state_active()
	globals.lamp_state_changed.emit(true)

func on_state_disabled():
	super.on_state_disabled()
	globals.lamp_state_changed.emit(false)
