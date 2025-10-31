extends AudioStreamPlayer

@export var baseTrack:AudioStream
##Tenseity goes up as the array value goes up
@export var tensenessLayers:Array[AudioStream]
@export var overlapLayers:bool = false
var playerRef:PlayerClass

func _ready() -> void:
	stream = baseTrack
	playing = true

var playOnce:bool = false
var stopOnce:bool = false
var musicLayer:AudioStreamPlayer 
func _process(delta: float) -> void:
	if get_parent() is generatingWorld:
		playerRef = get_parent().get_node("Player")
		musicLayer = AudioStreamPlayer.new()
		get_parent().add_child(musicLayer)
		musicLayer.bus = "Music"
		if playerRef.health_component.HealthPoints > 50:
			musicLayer.stream = tensenessLayers[0]
			if !playOnce:
				musicLayer.play()
				playOnce = true
		if playerRef.health_component.HealthPoints <= 50:
			if !stopOnce:
				musicLayer.stop()
				playOnce = false
				stopOnce = true
			musicLayer.stream = tensenessLayers[1]
			if !playOnce:
				musicLayer.play(get_playback_position())
				playOnce = true
