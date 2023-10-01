extends Node

@export var monster_anim_player: AnimationPlayer
@export var transition_anim_player: AnimationPlayer
@export var camera: PlayerCamera
@export var tablet: Tablet

var alertness: float = 0
var can_update_alertness: bool = false
var base_alert_rate: float = 0.3
var tablet_alert_rate: float = 0.3
var chartype_alert_rate: float = 0.5

var _num_commands_resolved: int = 0
var _monster_awake: bool = false
var _monster_anim_playing: bool = false
var _monster_frenzy: bool = false
var _charged_yet: bool = false

var _game_won: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.command_resolved.connect(_on_command_resolved)
	EventBus.char_typed.connect(_on_char_typed)
	EventBus.logged_in.connect(_on_login)
	EventBus.number_called.connect(_on_number_called)
	
func _process(delta):
	show_alertness()
	update_alertness(delta)
	
func update_alertness(delta):
	if !_monster_awake or !can_update_alertness or _game_won:
		return
		
	alertness += base_alert_rate * delta
	if tablet.is_on:
		alertness += tablet_alert_rate * delta
		
	if alertness >= 40 and alertness < 42:
		$HorrorMusic.set_db(-15, 0.5)
	if alertness >= 50:
		if _monster_frenzy:
			if !_charged_yet:
				monster_charge()
				_charged_yet = true
			else:
				if randf() < 0.5:
					begin_slow_walk()
				else:
					monster_charge()
		else:
			begin_slow_walk()
		
func _on_char_typed():
	if can_update_alertness and _monster_awake:
		alertness += chartype_alert_rate
		
func show_alertness():
	$Label.text = 'ALERTNESS: %d' % alertness
	
func _on_login():
	tablet_alert_rate = 0.5
	base_alert_rate = 0.4
	chartype_alert_rate = 0.7
	_monster_frenzy = true

func _on_command_resolved(command: String):
	_num_commands_resolved += 1
	if _num_commands_resolved >= 3 && !_monster_awake:
		wake_monster()
		
func _on_number_called():
	if _game_won:
		return
	_game_won = true
	alertness = 0
	$Ringtone.play()
	transition_anim_player.play('outside_fade_to_black')
	await transition_anim_player.animation_finished
	monster_anim_player.play('RESET')
	transition_anim_player.play('outside_fade_from_black')
	await get_tree().create_timer(2).timeout
	monster_anim_player.play('last_charge')
	await get_tree().create_timer(4).timeout
	$Ringtone.stop()

func wake_monster():
	await get_tree().create_timer(randf_range(3, 9)).timeout
	
	if _monster_awake:
		return
		
	$Footsteps1.play()
	await get_tree().create_timer(3).timeout
		
	_monster_awake = true
	can_update_alertness = true
	camera.shake(16, 2)
	camera.fall_down(5)
	tablet.drop_tablet_effect(7)
	$Banging1.play()
	
	await get_tree().create_timer(5).timeout
	alertness = randf_range(10, 30)
	
	$PlayerBreathingSFX.play()
	await get_tree().create_timer(8).timeout
	$PlayerBreathingSFX.stop()
	
func bang_locker():
	camera.shake(16, 2)
	camera.fall_down(5)
	tablet.drop_tablet_effect(10)
	$Banging1.play()
	
	await get_tree().create_timer(5).timeout
	
	$PlayerBreathingSFX.play()
	await get_tree().create_timer(15).timeout
	$PlayerBreathingSFX.stop()
	
func monster_charge():
	if _monster_anim_playing:
		return
	_monster_anim_playing = true
	
	$HorrorMusic.set_db(0, 0.5)
	monster_anim_player.play('charge')
	await monster_anim_player.animation_finished
	await get_tree().create_timer(randf_range(5, 15)).timeout
	
	if alertness < 70:
		transition_anim_player.play('outside_fade_to_black')
		await transition_anim_player.animation_finished
		monster_anim_player.play('RESET')
		transition_anim_player.play('outside_fade_from_black')
		_monster_anim_playing = false
		$HorrorMusic.set_db(-30, 0.1)
		alertness = randf_range(-40, 0)
	else:
		transition_anim_player.play('player_death')

func begin_slow_walk():
	if _monster_anim_playing:
		return
	_monster_anim_playing = true
	
	$HorrorMusic.set_db(-5, 1)
	monster_anim_player.play('slow_walk_left')
	await monster_anim_player.animation_finished
	await get_tree().create_timer(randf_range(0, 8)).timeout
	
	if alertness < 60:
		monster_anim_player.play('slow_walk_right')
		await monster_anim_player.animation_finished
		monster_anim_player.play('RESET')
		_monster_anim_playing = false
		if _monster_frenzy:
			$HorrorMusic.set_db(-30, 0.2)
			alertness = randf_range(-40, 0)
		else:
			$HorrorMusic.set_db(-80, 0.2)
			alertness = randf_range(-10, 20)
	elif alertness >= 60 and alertness < 75:
		transition_anim_player.play('outside_fade_to_black')
		await transition_anim_player.animation_finished
		monster_anim_player.play('RESET')
		transition_anim_player.play('outside_fade_from_black')
		_monster_anim_playing = false
		if _monster_frenzy:
			$HorrorMusic.set_db(-30, 0.1)
			alertness = randf_range(-40, 0)
		else:
			$HorrorMusic.set_db(-80, 0.1)
			alertness = randf_range(-10, 20)
	else:
		transition_anim_player.play('player_death')
