extends Node
class_name DamageSource

## Damage dealt.
@export var atk: int = 0
## Milliseconds duration to be invicible after attack.
## This doesn't do anything, its just read.
@export var iframe_duration: int = 0
## Whether the attack is continuous or not.
@export var is_continuous: bool = false
## Frequency of dealing damage if continuous.
@export var repeat_duration: int = 100

## When the player first got in contact.
var _contact_start_time: Dictionary[PlayerBulletHell, int] = {}
var _contact_update_time: Dictionary[PlayerBulletHell, int] = {}

func _ready():
	add_to_group("DamageSource", true)

func _process(delta: float):
	# If the player is alr tracked, but its not a continuous attack
	# never deal damage to the player until they are out of collision.
	# TODO: optionally delete the bullet now
	if not is_continuous:
		return null
	
	for player
	
	# Check if invincibility is over
	if delta * 1000 > repeat_duration:
		_contact_update_time[player] = now
		return atk
	
	return null

## Return how much damage is dealt, or null if no damage is dealt
## (as opposed to 0 damage).
func on_hit(player: PlayerBulletHell):
	var now = Time.get_ticks_msec()
	
	# Deal the initial damage and start tracking the player.
	if player not in _contact_start_time:
		_contact_start_time[player] = now
		_contact_update_time[player] = now
		player.take_damage(atk)
		
	player.take_damage(null)


## Reset player tracking.
func on_leave(player: PlayerBulletHell):
	_contact_start_time.erase(player)
	_contact_update_time.erase(player)
