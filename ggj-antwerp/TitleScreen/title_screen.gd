extends Node2D

@onready var anim := $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	anim.play("pressed")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://Levels/test_level.tscn")


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()
