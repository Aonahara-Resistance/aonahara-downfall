extends Node
class_name StateMachine

var previous_state = -1
var state: int = -1 : set = set_state
var character: Character
var animation_tree: AnimationTree
var animation_mode: AnimationNodeStateMachinePlayback


func setup(_character: Character, _animation_tree: AnimationTree) -> void:
  character = _character
  animation_tree = _animation_tree
  animation_mode = animation_tree.get("parameters/playback")


func _physics_process(delta) -> void:
  if state != -1:
    state_logic(delta)
    var transition: int = get_transition()
    if transition != -1:
      set_state(transition)


func state_logic(_delta) -> void:
  pass


func get_transition() -> int:
  return -1


func set_state(new_state: int) -> void:
  exit_state(state)
  previous_state = state
  state = new_state
  enter_state(previous_state, state)


func enter_state(_previous_state: int, _new_state: int) -> void:
  pass


func exit_state(_state_exited: int) -> void:
  pass
