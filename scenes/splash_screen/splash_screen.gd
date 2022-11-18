extends Node2D
class_name SplashScreen

@onready var splash_background: Node2D = %Background
@onready var white: ColorRect = %White

func _ready():
  var tween: Tween = create_tween()
  tween.parallel().tween_property(white, "color:a", 0, 1.0)
  tween.parallel().tween_property(splash_background, "global_position", splash_background.global_position + Vector2(1000,0), 5.0)





