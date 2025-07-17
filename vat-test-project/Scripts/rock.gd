class_name Rock extends RigidBody3D

var crow_handler : CrowHandler

func _ready() -> void:
	gravity_scale = 2

func set_crow_handler(new_crow_handler):
	crow_handler = new_crow_handler

func _on_body_entered(_body: Node) -> void:
	crow_handler.ping(global_position)
	linear_velocity = Vector3.ZERO
