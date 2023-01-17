extends CanvasLayer

export (NodePath) var path_to_player

onready var player = get_node(path_to_player)

onready var healthbar = $HealthBar
onready var healthlabel = $HealthBar/HealthBarLabel
onready var manabar = $ManaBar
onready var manalabel = $ManaBar/ManaBarLabel
onready var xpbar = $XPBar
onready var xplabel = $XPBar/XPLabel
onready var levellabel = $LevelLabel
onready var tween = $Tween
onready var coincounter = $CoinCounter
onready var leveluplabel = $XPBar/LevelUpLabel
onready var leveluptimer = $XPBar/LevelUpLabel/LevelUpTimer


func _ready():
	healthbar.value = 100
	manabar.value = 100
	xpbar.value = 0
	leveluplabel.percent_visible = 0


func _on_Player_health_changed(health):
	if healthbar.value > (health / player.playerstats.max_hp) *  100:
		#minskning
		tween.interpolate_property(healthbar, "value", healthbar.value, health / (player.playerstats.max_hp) *  100, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	else:
		#ökning
		tween.interpolate_property(healthbar, "value", healthbar.value, health / (player.playerstats.max_hp) *  100, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	healthlabel.text = (str(player.current_hp) + " / " + str(player.playerstats.max_hp))
		
	
	

func _on_Player_coins_changed():
	coincounter.text = str(Globals.coins)


func _on_Player_xp_changed():
	levellabel.text = ("LVL ")
	tween.interpolate_property(xpbar, "value", xpbar.value, round((player.playerstats.experience / player.experience_required) * 100), 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	xplabel.text = (str(player.playerstats.experience) + " / " + str(player.experience_required))
	
	


func _on_Player_leveled_up() -> void:
	leveluplabel.text = ("Level " + str(player.playerstats.level) + " Reached!")
	tween.interpolate_property(leveluplabel, "percent_visible", 0, 1, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	leveluptimer.start()


func _on_LevelUpTimer_timeout() -> void:
	tween.interpolate_property(leveluplabel, "percent_visible", 1, 0, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

