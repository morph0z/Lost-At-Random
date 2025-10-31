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

func _process(_delta: float) -> void:
	print()
