extends Node

@export var skill_node_text: Label
@export var skillTree: WorldmapView
@onready var player_ui: PlayerGui = $"../../.."

var nodeName:String
var nodeDescription:String
var nodeCost:String

signal skillPurchased(resource)

func _ready() -> void:
	var nodes:Array =  skillTree.get_all_nodes().keys()
	var nodeStates:Array = skillTree.get_all_nodes().values()
	print(nodes[1])
	#print(skillTree.initial_item.get_node_data(nodes[1]))
	for i in nodeStates.size():
		if nodeStates[i] == 0:
			#skillTree.set_node_style_override(skillTree.initial_item, nodes[i], skillTree.style_can_activate)
			pass

@warning_ignore("unused_parameter")
func _on_worldmap_view_node_mouse_entered(path: NodePath, node_in_path: int, resource: WorldmapNodeData) -> void:
	nodeName = resource.name
	nodeCost = str(resource.cost)
	nodeDescription = resource.desc
	
	skill_node_text.text = nodeName + "\n\n" + nodeDescription + "\n" + "Cost: " + nodeCost
	skill_node_text.visible = true
	skill_node_text.global_position = get_viewport().get_mouse_position()

@warning_ignore("unused_parameter")
func _on_worldmap_view_node_mouse_exited(path: NodePath, node_in_path: int, resource: WorldmapNodeData) -> void:
	skill_node_text.visible = false

@warning_ignore("unused_parameter")
func _on_worldmap_view_node_gui_input(event: InputEvent, path: NodePath, node_in_path: int, resource: WorldmapNodeData) -> void:
	if event is InputEventMouseMotion:
		skill_node_text.global_position = event.global_position
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			print(str(path)+" "+str(node_in_path))
			if player_ui.skillpointComp.getSkillPoints() >= resource.cost:
				if skillTree.get_node_state(path, node_in_path) == 1:
					player_ui.skillpointComp.reduceSkillPoints(resource.cost)
					skillPurchased.emit(resource)
					skillTree.set_node_state(path, node_in_path, 2)
					skillTree.set_node_style_override(path, node_in_path, skillTree.style_can_activate)
				if skillTree.get_node_state(path, node_in_path) == 2:
					print("bought")
					skillTree.set_node_style_override(path, node_in_path, skillTree.style_active)
					
