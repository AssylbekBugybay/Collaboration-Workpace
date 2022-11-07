extends Control

onready var participants_ok_button = $HideButton
onready var participants_list_view: ItemList = $ItemList
puppet var puppet_current_location: String
var current_location: String
var is_open: bool = true

func _ready():
	participants_ok_button.connect("pressed", self, "_on_participants_ok_button_pressed")
	update()

func _process(_delta):
	if is_open:
		update()

func _draw():
	participants_list_view.clear()
	participants_list_view.add_item(str(Meeting.get_participant_name() , "(you) is in ", current_location))
	for p in Meeting.participants:
		if p != 1:
			var others_location = get_node(str("/root/Default/Participants/"+str(p))).get("current_location")
			participants_list_view.add_item(str(Meeting.participants[p]["Name"], " is in ", others_location))

func _test(message):
	if is_network_master():
		current_location = message
#	if is_network_master():
#		current_location = message
#		rset("puppet_current_location", current_location)
#	else:
#		current_location = puppet_current_location
#	current_location = message
#	var participants = Meeting.get_participant_list()
#	participants.sort()
#	participants_list_view.clear()
#	participants_list_view.add_item(Meeting.get_participant_name() + " (You)")
#	for p in participants:
#		participants_list_view.add_item(str(p["Name"], ", sfsfd", current_location))
#######
		
#	if is_network_master():
#		print("me")
#		current_location = puppet_current_location
#		print("location: ", puppet_current_location, " message: ", message)
##		rset("puppet_current_location", message)
#	else:
#		current_location = puppet_current_location
#	rset("current_location", message)

func _display_location(area: Area2D) -> void:
	if area.get("room_name") != null:
		#location.text = area.room_name
		print("Participant: ", area.room_name)


func _on_participants_ok_button_pressed() -> void:
	self.hide()
	$"../ParticipantsButton".show()
