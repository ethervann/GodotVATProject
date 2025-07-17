class_name CrowHandler extends Node

enum RavenType {VAT, Skeletal}

@export var area_size : int = 100
@export var segment_size : int = 1

@export var crows_per_segment : int = 1
@export var crow_to_spawn : RavenType

var segments = Array()
var crows = Array()
@onready var vat_crow_scene = load("res://Scenes/vat_crow.tscn")
@onready var anim_crow_scene = load("res://Scenes/anim_crow.tscn")

func _ready() -> void:
	initialize_segments()
	print(self.get_children().size())
	print(crows[8].global_position)

func ping(location : Vector3) -> void:
	var msD = Time.get_ticks_usec()
	for crow in crows:
		if crow.global_position.distance_to(location) <= 5:
			crow.flee()
	msD = Time.get_ticks_usec() - msD
	print("Pinged in " + str(float(msD)/1000000.0) + "ms.")

func spawn_crow(i : int, xpos : float, ypos : float, zpos : float):
	
	var crow
	
	match (crow_to_spawn):
		RavenType.VAT:
			crow = vat_crow_scene.instantiate()
		RavenType.Skeletal:
			crow = anim_crow_scene.instantiate()
	
	self.add_child(crow)
	crows[i] = crow
	crow.global_position = Vector3(xpos, ypos, zpos)
	crow.rotation.y = randf_range(0,3)


func initialize_segments() -> void:
	var msD = Time.get_ticks_usec()
	
	var side_count = area_size/segment_size
	var segment_count = side_count * side_count
	var half_seg = segment_size / 2.0
	var c_count = 0
	segments.resize(segment_count)
	crows.resize(crows_per_segment * segments.size())

	for i in range(segment_count):
		segments[i] = Segment.new()
		segments[i].xpos = i % side_count + (half_seg) - area_size/2
		segments[i].zpos = i / side_count + (half_seg) - area_size/2

		for x in range(crows_per_segment):
			spawn_crow(c_count, segments[i].xpos + randf_range(-half_seg, half_seg), 0.0, segments[i].zpos + randf_range(-half_seg, half_seg))
			c_count += 1
		
	msD = Time.get_ticks_usec() - msD
	print("Initialized in " + str(float(msD)/1000000.0) + "ms.")
