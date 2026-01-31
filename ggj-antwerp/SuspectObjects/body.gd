extends Node2D

@onready var mouse_drag_area := $Torso/MouseDragArea
var draggable := false
var is_hidden := false:
	set(value):
		if value:
			#$Sprite2D.modulate = Color.AQUAMARINE
			z_index = 0
		else:
			#$Sprite2D.modulate = Color.RED
			z_index = 2
		is_hidden = value
var dragging := false:
	set(value):
		if value:
			for part in body_parts:
				part.freeze = true
				
		elif !is_hidden:
			for part in body_parts:
				part.freeze = false
				
		dragging = value

@onready var torso := $Torso
var mouse_offset := Vector2.ZERO
var overlapping_area_count := 0
var total_area_count : int
var body_parts = []
var body_part_offsets = []
var velocity = Vector2.ZERO

func _ready():
	mouse_drag_area.mouse_entered.connect(_on_mouse_entered)
	mouse_drag_area.mouse_exited.connect(_on_mouse_exited)
	for area in $HideCheckAreas.get_children():
		area.area_entered.connect(on_dead_body_area_entered)
		area.area_exited.connect(on_dead_body_area_exited)
		total_area_count += 1
	z_index = 2
	
	for child in get_children():
		if child is RigidBody2D:
			body_parts.append(child)
			body_part_offsets.append(child.position - torso.position )
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and draggable:
		dragging = true
		mouse_offset = torso.position - get_global_mouse_position()
	if dragging:
		var direction = torso.position.direction_to(get_global_mouse_position() + mouse_offset)
		for i in len(body_parts):
			body_parts[i].move_and_collide(direction * 2000.0 * delta)
	if Input.is_action_just_released("click"):
		dragging = false
	if overlapping_area_count < total_area_count:
		is_hidden = false
	
func on_dead_body_area_entered(area : Area2D):
	overlapping_area_count += 1

func on_dead_body_area_exited(area : Area2D):
	overlapping_area_count -= 1

func _on_mouse_entered() -> void:
	draggable = true


func _on_mouse_exited() -> void:
	draggable = false
