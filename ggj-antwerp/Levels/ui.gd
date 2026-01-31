extends CanvasLayer


@onready var platter: TextureRect = $Control/Platter
@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

@export var ANIM_REPEAT_COUNT := 2

var times_anim_repeated := 0

func _on_call_button_pressed() -> void:
	animation_player.play("call")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "call":
		return
	times_anim_repeated += 1
	if times_anim_repeated >= ANIM_REPEAT_COUNT:
		animation_player.stop()
		times_anim_repeated = 0
		call_platter()
	else:
		animation_player.play("call")

func call_platter():
	animation_player.play("raise_platter")
