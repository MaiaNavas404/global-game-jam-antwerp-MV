extends Node2D

@export var STAIN_CAPACITY := 4

@onready var stain_life = STAIN_CAPACITY
const BUBBLE_PARTICLES = preload("uid://c3xd6e8bmmtfp")

var current_color : Color

var floor_blood_textures = [preload("uid://b45gpyy1wbfg0"), preload("uid://c8fb13iaj47dm"), preload("uid://d1v5uboelglke"), preload("uid://ffh0rwkhglnf"), preload("uid://dym1tmmyg73p3"), preload("uid://b5o858hkcpt57")]
var wall_blood_textures = [preload("uid://0d68gobuy6cq"), preload("uid://dwc40ln0mimwu"), preload("uid://c710beoe5ry0l"), preload("uid://7wq3j5bbc75b"), preload("uid://bs4n34cn4h21b"), preload("uid://cfkopcoj41j3x")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_color = $Sprite2D.modulate
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init_blood(wall : bool):
	if wall:
		$Sprite2D.texture = wall_blood_textures.pick_random()
	else:
		$Sprite2D.texture = floor_blood_textures.pick_random()

func _on_area_2d_area_exited(area: Area2D) -> void:
	stain_life -= 1
	var bubbles = BUBBLE_PARTICLES.instantiate()
	bubbles.position = position
	bubbles.emitting = true
	get_tree().get_current_scene().add_child(bubbles)
	if stain_life == 0:
		queue_free()
	else:
		$Sprite2D.modulate.a = float(stain_life) / float(STAIN_CAPACITY)
