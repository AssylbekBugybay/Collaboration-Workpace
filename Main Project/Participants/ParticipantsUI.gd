extends Control

onready var participants_ok_button = $ParticipantsPanel/HideButton
onready var participants_list_view: ItemList = $ParticipantsPanel/ItemList
onready var participants: Array = Meeting.get_participant_list()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# TODO: runned only once, need some implementation during realtime new participant enter
#Probably signal from default
func _ready():
	participants_ok_button.connect("pressed", self, "_on_participants_ok_button_pressed")
	participants.sort()
	participants_list_view.clear()
	participants_list_view.add_item(Meeting.get_participant_name() + " (You)")
	for p in participants:
		participants_list_view.add_item(p)

func _on_participants_ok_button_pressed() -> void:
	self.hide()
