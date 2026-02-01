extends Node2D

@export var CURSOR_CLICK_DURATION := 0.5
@export var lift_animation_phase := 0
@export var lift_animation_playing := false

@onready var animation_player: AnimationPlayer = $CanvasLayer/Control/AnimationPlayer
@onready var ui: CanvasLayer = $CanvasLayer
@onready var cursor_idle_sprite := preload("uid://o83towqvdmu1")
@onready var sponge_sprite := preload("uid://bp1322y53ypoc")
@onready var cursor_interact_sprite := preload("uid://sib4a4v1nb8k")
@onready var rope_sprite = preload("uid://dfnifkoev08sj")
@onready var level_animation := $LevelAnimations
@onready var lamp_overlay := $CanvasLayer/Control/LampColor
@onready var camera: Camera2D = $Camera2D
@onready var blood_spawner := $BloodSpawner
const BODY = preload("uid://cbg6ind5qhoef")
const SPONGE = preload("uid://cw66wgv4br3vm")
@onready var bodies: Node2D = $Bodies
var number_of_bodies : int
var stain_points := 10
var body_points := 50
var active_object_points := 5
var total_score : float = 0.0
var player_score : float = 0.0
@onready var score_label: Label = $CanvasLayer/Control/Stats/Score
@onready var stats: VBoxContainer = $CanvasLayer/Control/Stats
@onready var background_music := $BGM
@onready var sfx := $SFX
@onready var cop_bg_color: ColorRect = $CanvasLayer/Control/CopBGColor
const ELEVATOR_ATLAS := [preload("res://Score/ProgressionCutscene/level1_elevator.png"),preload("res://Score/ProgressionCutscene/level2_elevator.png"),
preload("res://Score/ProgressionCutscene/level3_elevator.png"),preload("res://Score/ProgressionCutscene/level4_elevator.png"), 
preload("res://Score/ProgressionCutscene/level5_elevator.png"), preload("res://Score/ProgressionCutscene/level6_elevator.png"),
preload("res://Score/ProgressionCutscene/level7_elevator.png"), preload("res://Score/ProgressionCutscene/level8_elevator.png"),
preload("res://Score/ProgressionCutscene/level9_elevator.png"), preload("res://Score/ProgressionCutscene/level10_elevator.png"),
preload("res://Score/ProgressionCutscene/level11_elevator.png"), preload("res://Score/ProgressionCutscene/level12_elevator.png"),
preload("res://Score/ProgressionCutscene/level13_elevator.png")]
var lost := false
const telephone_sfx = preload("uid://b0ce57svl451y")


var current_cursor_state := globals.Items.SPONGE:
	set(value):
		on_state_changed()
		current_cursor_state = value
var cursor_click_timer : Timer
var hotspot := Vector2(40, 40)

func _ready():
	if globals.level != 13:
		level_animation.play("level_start")
	else:
		level_animation.play("level_start_13")
	globals.active_object_count = 0
	stats.visible = false
	cop_bg_color.visible = false
	globals.level_ended = false
	get_viewport().physics_object_picking_first_only = true
	get_viewport().physics_object_picking_sort = true
	cursor_click_timer = Timer.new()
	add_child(cursor_click_timer)
	var player_sponge = SPONGE.instantiate()
	add_child(player_sponge)
	cursor_click_timer.wait_time = CURSOR_CLICK_DURATION
	cursor_click_timer.one_shot = true
	cursor_click_timer.timeout.connect(on_click_timer_end)
	globals.lamp_state_changed.connect(on_lamp_state_changed)
	randomize()
	on_lamp_state_changed(false)
	body_spawner()
	total_score_calculator()

func total_score_calculator():
	var number_of_stains : int = blood_spawner.get_node("SpawnedBlood").get_child_count()
	total_score += stain_points * number_of_stains
	total_score += body_points * number_of_bodies
	

func body_spawner():
	if globals.level < 5:
		number_of_bodies = int(globals.level/2)
	else:
		number_of_bodies = 2 + globals.level - 4
	var spawn_area_min : float = camera.bounds.x + 20
	var spawn_area_max : float = camera.bounds.y + 1920 - 20
	var spawn_height := 880
	
	for i in range(number_of_bodies):
		var spawn_position := Vector2(randf_range(spawn_area_min, spawn_area_max), spawn_height)
		var spawned_body = BODY.instantiate()
		spawned_body.position = spawn_position
		bodies.add_child(spawned_body)

func _physics_process(delta: float) -> void:
	if current_cursor_state != globals.current_item:
		current_cursor_state = globals.current_item
	if globals.current_item == globals.Items.NONE: 
		if Input.is_action_just_pressed("click"):
			Input.set_custom_mouse_cursor(cursor_interact_sprite, 0, hotspot)
		elif Input.is_action_just_released("click"):
			cursor_click_timer.start()
	if lift_animation_playing:
		play_lift_animation(delta)

func _on_sponge_button_pressed() -> void:
	if globals.current_item != globals.Items.SPONGE:
		globals.current_item = globals.Items.SPONGE
	else:
		globals.current_item = globals.Items.NONE
	ui.platter.texture = ui.platter_sprites[globals.current_item]
	animation_player.play("hide_platter")

func on_state_changed():
	if globals.current_item == globals.Items.NONE:
		Input.set_custom_mouse_cursor(cursor_idle_sprite, 0, hotspot)
	elif globals.current_item == globals.Items.SPONGE:
		Input.set_custom_mouse_cursor(sponge_sprite,0, hotspot)
	elif globals.current_item == globals.Items.ROPE:
		Input.set_custom_mouse_cursor(rope_sprite, 0, hotspot)

func on_click_timer_end():
	on_state_changed()


func _on_rope_button_pressed() -> void:
	if globals.current_item != globals.Items.ROPE:
		globals.current_item = globals.Items.ROPE
	else:
		globals.current_item = globals.Items.NONE
	ui.platter.texture = ui.platter_sprites[globals.current_item]
	animation_player.play("hide_platter")


func _on_bell_button_pressed() -> void:
	sfx.play()
	animation_player.play("hide_platter")
	level_animation.play("level_ended")
	globals.level_ended = true
	globals.current_item = globals.Items.NONE
	on_state_changed()
	

func play_lift_animation(delta):
	
	var frame_width := 1004
	var lift_texture: TextureRect = $CanvasLayer/Control/LiftTexture
	lift_texture.texture.atlas = ELEVATOR_ATLAS[globals.level-1]
	if globals.level == 13:
		var frame_height := 592
		lift_texture.texture.set_region(Rect2((lift_animation_phase % 8) * frame_width, (lift_animation_phase / 8) * frame_height, frame_width, frame_height))
		return
	lift_texture.texture.set_region(Rect2(lift_animation_phase * frame_width, 0, frame_width, 0))
	

func _on_level_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "transition":
		globals.level += 1
		if !lost:
			get_tree().reload_current_scene()
		else:
			get_tree().change_scene_to_file("res://TitleScreen/lose_screen.tscn")
	elif anim_name == "level_ended":
		stats.visible = true
		cop_bg_color.visible = true
		var cop_face: TextureRect = $CanvasLayer/Control/Stats/CopFace
		var cop_face_frame_width := 763
		var stains_left : int = blood_spawner.get_node("SpawnedBlood").get_child_count()
		var bodies_left := 0
		for body in bodies.get_children():
			if !body.is_hidden:
				bodies_left += 1
		player_score = total_score
		player_score -= stain_points * stains_left
		player_score -= body_points * bodies_left
		player_score -= active_object_points * globals.active_object_count
		score_label.text = "Score: " + str(int(player_score)) + "/" + str(int(total_score))
		var message_label = stats.get_node("Message")
		var cop_texture_region : Rect2
		if player_score == total_score:
			message_label.text = "PERFECT!!!"
		elif player_score / total_score >= 0.6:
			message_label.text = "Good Job!"
			cop_texture_region = Rect2(cop_face_frame_width, 0, cop_face_frame_width, 0)
		elif player_score / total_score >= 0.2:
			message_label.text = "Hopefully The Cops Don't Find It..."
			cop_texture_region = Rect2(0, 0, cop_face_frame_width, 0)
		elif player_score < 0.0:
			message_label.text = "How did you even do that..."
			cop_texture_region = Rect2(2 * cop_face_frame_width, 0, cop_face_frame_width, 0)
		elif player_score / total_score >= 0.0:
			message_label.text = "Yeah No You're Going To Jail."
			cop_texture_region = Rect2(2 * cop_face_frame_width, 0, cop_face_frame_width, 0)
			lost = true
		cop_face.texture.set_region(cop_texture_region)
	
func on_lamp_state_changed(state : bool):
	lamp_overlay.visible = !state


func _on_continue_pressed() -> void:
	level_animation.play("transition")
