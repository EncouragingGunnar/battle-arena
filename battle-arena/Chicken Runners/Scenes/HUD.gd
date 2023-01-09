extends CanvasLayer

export (NodePath) var path_to_player

onready var player = get_node(path_to_player)
onready var healthbar = $HealthBar
onready var healthlabel = $HealthLabel
onready var manabar = $ManaBar
onready var manalabel = $ManaLabel
onready var xpbar = $XPBar
onready var xplabel = $XPBar/XPLabel
onready var levellabel = $LevelLabel
onready var tween = $Tween
onready var coincounter = $CoinCounter

var max_hp = 100

func _ready():
	healthbar.value = 100
	manabar.value = 100
	xpbar.value = 0
	print(player)


func _on_Player_health_changed(health):
	if (healthbar.value * max_hp) / 100 > health:
		#minskning
		tween.stop_all()
		tween.interpolate_property(healthbar, "value", healthbar.value, health, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	else:
		#ökning
		tween.stop_all()
		tween.interpolate_property(healthbar, "value", healthbar.value, health, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	

func _on_Player_coins_changed(coins):
	coincounter.text = str(Globals.coins)


func _on_Player_xp_changed():
	levellabel.text = ("LVL " + str(player.level))
	tween.stop_all()
	tween.interpolate_property(xpbar, "value", xpbar.value, round(player.experience_required / player.experience), 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	xplabel.text = (str(player.experience) + " / " + str(player.experience_required))
	
