extends Node2D

var is_disabled := false

var queue_play_cleaning_audio := false
const CLEANING_AUDIOS := [preload("uid://cjba2f4t5ek3g"), preload("uid://bvl8fttl3au4x"), preload("uid://busl3i3eh7pt6")]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 3
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("click"):
		$SpongeArea.monitoring = true
		$SpongeArea.monitorable = true
	else:
		$SpongeArea.monitoring = false
		$SpongeArea.monitorable = false
	if globals.current_item == globals.Items.SPONGE:
		position = get_global_mouse_position()
		if is_disabled:
			visible = true
			is_disabled = false
	elif !is_disabled:
		visible = false
		is_disabled = true
	
func play_audio():
	var audio_to_play = CLEANING_AUDIOS.pick_random()
	$AudioStreamPlayer.stream = audio_to_play
	$AudioStreamPlayer.play()
	queue_play_cleaning_audio = false

func _on_audio_stream_player_finished() -> void:
	if queue_play_cleaning_audio:
		play_audio()


func _on_sponge_area_area_entered(area: Area2D) -> void:
	$Timer.start()
	if $AudioStreamPlayer.playing:
		queue_play_cleaning_audio = true
	else:
		play_audio()


func _on_timer_timeout() -> void:
	queue_play_cleaning_audio = false
	$AudioStreamPlayer.stop()
