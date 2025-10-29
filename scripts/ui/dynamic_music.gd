extends AudioStreamPlayer

@export var baseTrack:AudioStream
##Tenseity goes up as the array value goes up
@export var tensenessLayers:Array[AudioStream]
@export var overlapLayers:bool = false
var playerRef:PlayerClass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = baseTrack
	playing = true

var playOnce = false
var stopOnce = false
func _process(delta: float) -> void:
	if get_parent().get_node("Player"):
		playerRef = get_parent().get_node("Player")
	if !overlapLayers:
		var tenseLayer = AudioStreamPlayer.new()
		var tenseLayerStream:AudioStreamMP3
		if playerRef:
			if playerRef.health_component.HealthPoints >= 60:
				tenseLayerStream = tensenessLayers[0]
				if !playOnce:
					tenseLayer.stream = tenseLayerStream
					tenseLayer.play()
					playOnce = true
			if (playerRef.health_component.HealthPoints < 60) and (playerRef.health_component.HealthPoints > 20):
				tenseLayerStream = tensenessLayers[1]
				if !playOnce:
					tenseLayer.stream = tenseLayerStream
					tenseLayer.play()
					playOnce = true
			if playerRef.health_component.HealthPoints < 20:
				tenseLayerStream = tensenessLayers[2]
				if !playOnce:
					tenseLayer.stream = tenseLayerStream
					tenseLayer.play()
					playOnce = true
			get_parent().add_child(tenseLayer)
			tenseLayer.autoplay = true
