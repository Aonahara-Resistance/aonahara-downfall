extends CharacterBody2D
class_name Character

@export var acceleration: int = 150
@export var friction: float = 0.7
@export var stamina: int
@export var max_stamina: int
@export var dash_speed: int
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 2

@onready var sprite: Sprite2D = $Sprite

var state_machine: StateMachine

var movement_key: Dictionary = {
  "up": false,
  "down": false,
  "left": false,
  "right": false,
}


func _ready() -> void: 
  state_machine = $StateMachine as StateMachine
  state_machine.setup(self, $AnimationTree)


func _physics_process(delta: float) -> void:
  move(delta)


func _unhandled_key_input(event: InputEvent) -> void:
  listen_to_input_direction(event)


func move(delta: float) -> void:
  var input_direction: Vector2 = get_input_direction()
  move_and_slide()
  velocity += acceleration * input_direction * delta * 60
  velocity = lerp(velocity, Vector2.ZERO, friction)


func get_input_direction() -> Vector2:
  var input_direction: Vector2 = Vector2.ZERO
  input_direction.x = (int(movement_key["right"]) - int(movement_key["left"]))
  input_direction.y = (int(movement_key["down"]) - int(movement_key["up"]))
  input_direction = input_direction.normalized()
  return input_direction


func listen_to_input_direction(event: InputEvent) -> void:
  if event.is_action_pressed("up"):
    movement_key["up"] = true
  if event.is_action_pressed("down"):
    movement_key["down"] = true
  if event.is_action_pressed("left"):
    movement_key["left"] = true
  if event.is_action_pressed("right"):
    movement_key["right"] = true
  if event.is_action_released("up"):
    movement_key["up"] = false
  if event.is_action_released("down"):
    movement_key["down"] = false
  if event.is_action_released("left"):
    movement_key["left"] = false
  if event.is_action_released("right"):
    movement_key["right"] = false


func get_mouse_direction() -> Vector2:
  return (get_global_mouse_position() - global_position).normalized()

