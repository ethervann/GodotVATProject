extends Node3D

@export var vat_text : Texture2D

const MOVE_SPEED = .5
const ANIM_SPEED = 40

var mesh : MeshInstance3D = self.get_child(0)
var mat : Material = mesh.material_override

var anim_timer : float
var flee_timer : float
var fleeing : bool
var fly_velocity : Vector3

var anim_regions : Dictionary = {"idle" : Vector2(23, 130) , "fly" : Vector2(0.5, 56.5), "itch" : Vector2(131, 69)}
var atlas : AtlasTexture

func _ready() -> void:
	update_anim("idle")
	mesh.set_instance_shader_parameter("sheen_color_strength", randf_range(0, 2))
	anim_timer = randf_range(0.0, 200.0)
	
func _process(delta: float) -> void:
	anim_timer += delta * ANIM_SPEED
	
	mesh.set_instance_shader_parameter("frame", anim_timer)

	if fleeing:
		bump_pos(delta)
	#end

func update_anim(anim : String) -> void:
	mesh.set_instance_shader_parameter("y_start", anim_regions[anim].x)
	mesh.set_instance_shader_parameter("y_length", anim_regions[anim].y)

	#end

func flee() -> void:
	update_anim("fly")
	
	fly_velocity = Vector3(randf_range(-4.0, 4.0), randf_range(2.0, 5.5), randf_range(-4.0, 4.0))
	
	self.look_at(global_position + -fly_velocity)
	
	fleeing = true
	
	#end
	
func bump_pos(delta):
	position = position + fly_velocity * delta * MOVE_SPEED
	
	#end
