extends RoomProps


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	$AnimationPlayer.seek(0.3)

func _physics_process(delta: float) -> void:
	if globals.level_ended:
		$AudioStreamPlayer.playing = false
	super._physics_process(delta)

func on_state_active():
	if $AnimationPlayer.is_playing():
		return
	$AnimationPlayer.play("open")
	await $AnimationPlayer.animation_finished
	super.on_state_active()
	

func on_state_disabled():
	if $AnimationPlayer.is_playing():
		return
	super.on_state_disabled()
	$AnimationPlayer.play("close")
	
	
