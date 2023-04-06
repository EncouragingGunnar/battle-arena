extends CanvasLayer

onready var healthbar = $HealthBar
onready var healthlabel = $HealthBar/HealthBarLabel
#onready var manabar = $ManaBar
#onready var manalabel = $ManaBar/ManaBarLabel
onready var xpbar = $XPBar
onready var xplabel = $XPBar/XPLabel
onready var levellabel = $LevelLabel
onready var tween = $Tween
onready var coincounter = $CoinCounter
onready var leveluplabel = $XPBar/LevelUpLabel
onready var leveluptimer = $XPBar/LevelUpLabel/LevelUpTimer


func _ready() -> void:
	healthbar.value = 100
	#manabar.value = 100
	xpbar.value = 0
	leveluplabel.percent_visible = 0
	


func _on_Player_health_changed(health: int, max_health: int) -> void:
	"""
	tar in ny health och max health, kollar om någon av dem är större eller mindre än det förra värdet
	och uppdaterar därefter display
	"""
	if healthbar.value > (health / max_health) *  100:
		#minskning
		tween.interpolate_property(healthbar, "value", healthbar.value, float(health) / max_health *  100, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	else:
		#ökning
		tween.interpolate_property(healthbar, "value", healthbar.value, float(health) / max_health *  100, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	healthlabel.text = (str(health) + " / " + str(max_health))
		
	
	

func _on_Player_coins_changed() -> void:
	"""
	tar nya mängden coins från global coins, kallas i player när plockar upp coin
	"""
	coincounter.text = str(Globals.coins)


func _on_Player_xp_changed(experience: int, experience_required: int) -> void:
	"""
	tar nuvarande experience mot nästa nivå och experience som krävs för att levla upp
	uppdaterar bars med mya värden
	"""
	levellabel.text = ("LVL ")
	tween.interpolate_property(xpbar, "value", xpbar.value, float(experience) / experience_required * 100, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	xplabel.text = (str(experience) + " / " + str(experience_required))
	
	
func _on_Player_leveled_up() -> void:
	"""
	tar level från globals och visar text som visar vilken level man är i, anropas av spelaren
	"""
	leveluplabel.text = ("Level " + str(Globals.level) + " Reached!")
	tween.interpolate_property(leveluplabel, "percent_visible", 0, 1, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	leveluptimer.start()


func _on_LevelUpTimer_timeout() -> void:
	"""
	tar bort levelup baren 
	"""
	tween.interpolate_property(leveluplabel, "percent_visible", 1, 0, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()



