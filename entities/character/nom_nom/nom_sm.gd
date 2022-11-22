extends StateMachine

enum States { 
  Idle,
  Move
}

func setup(_character: Character, _animation_tree: AnimationTree) -> void:
  super.setup(_character, _animation_tree)
  set_state(States.Idle)


func _unhandled_input(event: InputEvent) -> void:
  if state == States.Idle:
    character.listen_to_input_direction(event)
  if state == States.Move:
    character.listen_to_input_direction(event)


func state_logic(_delta) -> void:
  animation_tree.set("parameters/idle/blend_position", character.get_mouse_direction().x)
  animation_tree.set("parameters/move/blend_position", character.get_mouse_direction().x)


func enter_state(_previous_state: int, new_state: int) -> void:
  match new_state:
    States.Move:
      animation_mode.travel("move")
    States.Idle:
      animation_mode.travel("idle")


func get_transition() -> int:
  match state:
    States.Idle:
      if character.velocity.length() > 10:
        return States.Move
    States.Move:
      if character.velocity.length() < 10:
        return States.Idle

  return -1
