extends Node2D


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
				part.gravity_scale = 1
				current_dragged_body_part.freeze = true
				#part.freeze = true
				
		elif !is_hidden:
			for part in body_parts:
				part.gravity_scale = 1
				part.linear_velocity = Vector2.ZERO
				part.freeze = false
		dragging = value

@onready var torso := $Torso
var mouse_offset := Vector2.ZERO
var overlapping_area_count := 0
var total_area_count : int
var body_parts = []
var body_part_mouse_areas = []
var body_part_offsets = []
var current_dragged_body_part:
	set(value):
		if value == null:
			draggable = false
		else:
			draggable = true
		current_dragged_body_part = value
var velocity = Vector2.ZERO

func _ready():
	z_index = 2
	
	for child in get_children():
		if child is RigidBody2D:
			body_parts.append(child)
			body_part_offsets.append(child.position - torso.position )
	
	for part in body_parts:
		
		for child in part.get_children():
			if child.is_in_group("HideAreaCheck"):
				var area = child
				area.area_entered.connect(on_dead_body_area_entered)
				area.area_exited.connect(on_dead_body_area_exited)
				total_area_count += 1
			elif child.is_in_group("MouseArea"):
				var area = child
				area.connect("mouse_entered", self._on_mouse_entered, CONNECT_APPEND_SOURCE_OBJECT)
				area.connect("mouse_exited", self._on_mouse_exited, CONNECT_APPEND_SOURCE_OBJECT)
				
			

func _physics_process(delta: float) -> void:
	print(draggable, dragging)
	if Input.is_action_just_pressed("click") and draggable and globals.current_item != globals.Items.SPONGE:
		dragging = true
		
		mouse_offset = current_dragged_body_part.position - get_global_mouse_position()
	if dragging and current_dragged_body_part.position.distance_to(get_global_mouse_position() + mouse_offset) > 50:
		var direction = current_dragged_body_part.position.direction_to(get_global_mouse_position() + mouse_offset)
		var distance = current_dragged_body_part.position.distance_to(get_global_mouse_position() + mouse_offset)
		#torso.move_and_collide(direction * 3000.0 * delta)
		for i in len(body_parts):
			body_parts[i].move_and_collide(direction * 3000.0 * distance / 300.0 * delta)
			
	if Input.is_action_just_released("click"):
		dragging = false
		current_dragged_body_part = null
	if overlapping_area_count < total_area_count:
		is_hidden = false
	if current_dragged_body_part != null: print(current_dragged_body_part.name)
	
	
func on_dead_body_area_entered(area : Area2D):
	overlapping_area_count += 1

func on_dead_body_area_exited(area : Area2D):
	overlapping_area_count -= 1

func _on_mouse_entered(area : Area2D) -> void:
	if dragging:
		return
	var body = area.get_parent()
	set_deferred("current_dragged_body_part", body)
	#draggable = true
	
func _on_mouse_exited(area : Area2D) -> void:
	if dragging:
		return
	if current_dragged_body_part == area.get_parent():
		current_dragged_body_part = null
	#draggable = false
