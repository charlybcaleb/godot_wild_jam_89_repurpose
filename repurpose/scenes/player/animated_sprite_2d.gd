extends AnimatedSprite2D

func _ready() -> void:
	play("default")

func _process(_delta: float) -> void:
	var current_anim_name: String = animation
	if get_owner().moving and current_anim_name != "walk":
		play("walk")
	elif !get_owner().moving and current_anim_name != "default":
		play("default")
