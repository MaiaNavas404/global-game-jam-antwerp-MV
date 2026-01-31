extends Node2D

@export var CURSOR_CLICK_DURATION := 0.5

@onready var sponge: Node2D = $Sponge
@onready var animation_player: AnimationPlayer = $CanvasLayer/Control/AnimationPlayer
@onready var ui: CanvasLayer = $CanvasLayer
@onready var cursor_idle_sprite := preload("uid://o83towqvdmu1")
@onready var sponge_sprite := preload("uid://bp1322y53ypoc")
@onready var cursor_interact_sprite := preload("uid://sib4a4v1nb8k")
@onready var rope_sprite = preload("uid://dfnifkoev08sj")


var current_cursor_state := globals.Items.SPONGE:
	set(value):
		on_state_changed()
		current_cursor_state = value
var cursor_click_timer : Timer
var hotspot := Vector2(40, 40)

func _ready():
	get_viewport().physics_object_picking_first_only = true
	get_viewport().physics_object_picking_sort = true
	cursor_click_timer = Timer.new()
	add_child(cursor_click_timer)
	cursor_click_timer.wait_time = CURSOR_CLICK_DURATION
	cursor_click_timer.one_shot = true
	cursor_click_timer.timeout.connect(on_click_timer_end)

func _physics_process(delta: float) -> void:
	if current_cursor_state != globals.current_item:
		current_cursor_state = globals.current_item
	if globals.current_item == globals.Items.NONE: 
		if Input.is_action_just_pressed("click"):
			Input.set_custom_mouse_cursor(cursor_interact_sprite, 0, hotspot)
		elif Input.is_action_just_released("click"):
			cursor_click_timer.start()

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
