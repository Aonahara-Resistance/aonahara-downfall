extends Node2D
class_name Dash

signal dash_started
signal dash_ended

@export var ghost_scene: PackedScene = preload("res://common/dash/dash_ghost.tscn")

@onready var duration_timer: Timer = $DurationTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var ghost_spawn_interval_timer: Timer = $GhostSpawnIntervalTimer
@onready var dust_trail: GPUParticles2D = $DustTrail
@onready var dust_burst: GPUParticles2D = $DustBurst

var dash_sprite: Sprite2D
var dash_sprite_shader: ShaderMaterial
var character: Character

const stamina_cost = 1

func setup(_character: Character) -> void:
  character = _character
  duration_timer.set_wait_time(character.dash_duration)
  cooldown_timer.set_wait_time(character.dash_cooldown)
  dash_sprite = character.sprite
  dash_sprite_shader = dash_sprite.material


func start_dash() -> void:
  if can_dash():
    apply_dash_speed()
    start_timers()
    emit_signal("dash_started")
    GameSignal.emit_signal("dash_started")


func apply_dash_speed() -> void:
  character.stamina = character.stamina - stamina_cost
  character.acceleration = character.acceleration + character.dash_speed


func restore_dash_speed() -> void:
  character.acceleration = character.acceleration - character.dash_speed


func can_dash() -> bool:
  if character.stamina <= 0:
    return false
  if cooldown_timer.is_stopped():
    return false
  return true


func start_timers():
  cooldown_timer.start()
  duration_timer.start()
  ghost_spawn_interval_timer.start()


func create_trails(direction: Vector2):
  dust_burst.set_rotation((direction * -1).angle())
  dust_trail.restart()
  dust_trail.set_emitting(true)
  dust_burst.restart()
  dust_burst.set_emitting(true)


func instance_ghost() -> void:
  var ghost: Sprite2D = ghost_scene.instantiate()
  var ghost_target = get_tree().get_current_scene()

  ghost_target.add_child(ghost)
  ghost.global_position = global_position
  ghost.texture = dash_sprite.texture
  ghost.vframes = dash_sprite.vframes
  ghost.hframes = dash_sprite.hframes
  ghost.frame = dash_sprite.frame
  ghost.flip_h = dash_sprite.flip_h


func end_dash() -> void:
  restore_dash_speed()
  dash_sprite_shader.set_shader_parameter("whiten", false)
  ghost_spawn_interval_timer.stop()
  emit_signal("dash_ended")


func _on_duration_timer_timeout() -> void:
  pass # Replace with function body.


func _on_ghost_spawn_interval_timer_timeout() -> void:
  pass # Replace with function body.


func _on_cooldown_timer_timeout() -> void:
  pass # Replace with function body.
