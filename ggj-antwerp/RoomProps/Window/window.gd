extends RoomProps


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	

func on_state_active():
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished
	super.on_state_active()
	

func on_state_disabled():
	super.on_state_disabled()
	$AnimationPlayer.play("close")
	
	
