extends Node2D


var draggable := false
var hidable : bool
var is_hidden := false:
	set(value):
		if value:
			for part in body_parts:
				part.freeze = true
				
			z_index = 0
		else:
			for part in body_parts:
				if part != current_dragged_body_part:
					part.freeze = false
			z_index = 2
			
		is_hidden = value
var dragging := false:
	set(value):
		if value:
			current_dragged_body_part.freeze = true
		else:
				current_dragged_body_part.freeze = false
		dragging = value

@onready var torso := $Torso
var mouse_offset := Vector2.ZERO
var overlapping_area_count := 0
var total_area_count : int
var body_parts = []
var body_part_mouse_areas = []
var body_part_hide_areas = []
var body_part_offsets = []
var current_dragged_body_part:
	set(value):
		if value == null:
			draggable = false
		else:
			draggable = true
		current_dragged_body_part = value
var velocity = Vector2.ZERO
var is_tied := false

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
				body_part_hide_areas.append(child)
			elif child.is_in_group("MouseArea"):
				var area = child
				area.connect("mouse_entered", self._on_mouse_entered, CONNECT_APPEND_SOURCE_OBJECT)
				area.connect("mouse_exited", self._on_mouse_exited, CONNECT_APPEND_SOURCE_OBJECT)
				
	

func _physics_process(delta: float) -> void:
	hidable = check_hiding()
	if Input.is_action_just_pressed("click") and draggable and globals.current_item != globals.Items.SPONGE:
		if globals.current_item == globals.Items.ROPE:
			tie_body()
			return
		dragging = true
		mouse_offset = current_dragged_body_part.position - get_global_mouse_position()
	if dragging and current_dragged_body_part.position.distance_to(get_global_mouse_position() + mouse_offset) > 50:
		var direction = current_dragged_body_part.position.direction_to(get_global_mouse_position() + mouse_offset)
		var distance = current_dragged_body_part.position.distance_to(get_global_mouse_position() + mouse_offset)
		#torso.move_and_collide(direction * 3000.0 * delta)
		for i in len(body_parts):
			body_parts[i].move_and_collide(direction * 3000.0 * distance / 300.0 * delta)
			
	if Input.is_action_just_released("click") and dragging:
		dragging = false
		current_dragged_body_part = null
	
	if is_hidden and !check_hiding() and dragging:
		is_hidden = false
	


func tie_body():
	if !is_tied:
		for part in body_parts:
			part.lock_rotation = true
		is_tied = true
	else:
		for part in body_parts:
			part.lock_rotation = false
		is_tied = false

func check_hiding() -> bool:
	if overlapping_area_count >= total_area_count and !check_overlapping_bodies():
		return true
	return false

func on_dead_body_area_entered(area : Area2D):
	if area.is_in_group("HideableArea"):
		overlapping_area_count += 1
		

func check_overlapping_bodies() -> bool:
	for area in body_part_hide_areas:
		for overlapping_area in area.get_overlapping_areas():
			if overlapping_area.is_in_group("HideAreaCheck") and overlapping_area.get_parent().get_parent() != self:
				return true
	return false
func on_dead_body_area_exited(area : Area2D):
	if area.is_in_group("HideableArea"):
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
