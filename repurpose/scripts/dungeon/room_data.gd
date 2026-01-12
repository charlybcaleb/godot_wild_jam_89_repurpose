class_name RoomData
extends Resource

@export var name:= "tomb" # used to get path and load node, and for tooltip
@export var weight := 1 # weight to appear as next room option
# soul room stuff
@export var resource := GlobalConstants.ResourceType.MP
@export var wu_needed := 3 # each soul nets 1 wu per tick
@export var output_amt := 1
