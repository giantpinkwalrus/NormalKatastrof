extends Sprite

export var max_health = 150
var min_health = 0
export var repair_rate = 10
export var kick_degradation = 15
export var time_degradation = 5
export var tick_time : float = 5
var current_health = max_health
signal part_broken
signal shake

export(int, "Torpedo", "Periscope", "Water", "Engine", "Sonar", "Ballast Front", "Ballast Back") var terminal_type
# Called when the node enters the scene tree for the first time.
func _ready():
	$DamageTimer.start(tick_time)

func kick(player):
	emit_signal("shake")
	$Thud.pitch_scale = 1 + rand_range(-0.05, 0.75)
	$Thud.play()
	damage(-kick_degradation)
	owner.action(self, player)

func fix():
	emit_signal("shake")
	$FixSound.pitch_scale = 1 + rand_range(-0.05, 0.75)
	$FixSound.play()
	current_health = clamp(current_health + repair_rate, 0, max_health)

func is_broken():
	return current_health == 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$HealthBar.value = float(current_health) / float(max_health) * 100

func damage(amount):
	if is_broken():
		emit_signal("part_broken")
		return
	current_health = clamp(current_health + amount, 0, max_health)

func _on_DamageTimer_timeout():
	damage(-time_degradation)


