extends Node3D

var anims : Dictionary = {"idle" : "root_001|Unreal Take|Base Layer", "fly" : "root_001|Unreal Take|Base Layer_003", "itch" : "root|Unreal Take|Base Layer_002"}
var anim_player : AnimationPlayer 
var next_anim : String
var fly_velocity : Vector3
var fleeing : bool
const MOVE_SPEED = .4

@export var anim_speed : float = 0.75

func _ready() -> void:
	anim_player = get_child(1)
	anim_player.speed_scale = anim_speed * randf_range(0.9, 1.1)
	anim_player.play(anims["idle"])
	next_anim = anims["idle"]
	
	#end

func _physics_process(delta: float) -> void:
	if fleeing:
		bump_pos(delta)
	
	#end

func update_anim(new_anim : String):
	anim_player.play(anims[new_anim])
	
	#end

func flee() -> void:
	update_anim("fly")
	anim_player.speed_scale = randf_range(.9, 1.1)
	
	fly_velocity = Vector3(randf_range(-4.0, 4.0), randf_range(2.0, 5.5), randf_range(-4.0, 4.0))
	
	self.look_at(global_position + -fly_velocity)
	
	fleeing = true
	
	#end

func bump_pos(delta):
	position = position + fly_velocity * delta * MOVE_SPEED
	
	#end

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == anims["idle"] || anim_name == anims["itch"]:
		if randi()%2 == 0:
			next_anim = anims["idle"]
		else: next_anim = anims["itch"]
		
	else: next_anim = anims["fly"]
	anim_player.play(next_anim)
	
	#end
