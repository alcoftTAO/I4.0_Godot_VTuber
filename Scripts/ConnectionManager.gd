extends Node

@export var Ip: String = "127.0.0.1"
@export var Port: int = 2052
@export var ObjsManager: Node = null
var Peer: StreamPeerTCP = null

func SendData(data: PackedByteArray):
	Peer.put_data(data)

func SendMessage(message: String):
	SendData(var_to_bytes(message))

func WaitForReceiveMessage() -> String:
	var available_bytes = Peer.get_available_bytes()
	var data_bytes = Peer.get_partial_data(available_bytes)[1]
	
	return data_bytes.get_string_from_utf8()

func Connect():
	var Connected = Peer.connect_to_host(Ip, Port)
	Peer.poll()
	
	if (Connected != OK):
		print("Error connecting...")
		return
	
	print("Connected!")

func __send_to_objm__(value, obj: String):
	ObjsManager.call("SetAutoData", value, obj)

func _ready():
	Peer = StreamPeerTCP.new()
	Peer.set_no_delay(false)

func _process(_delta):
	if (Peer.get_status() != StreamPeerTCP.STATUS_CONNECTED):
		Connect()
	
	var message = WaitForReceiveMessage()
	var lmessage = message.to_lower()
	
	if (len(lmessage) > 0):
		if (lmessage.begins_with("cap ")):
			__send_to_objm__(message.substr(4), "captions")
		elif (lmessage.begins_with("loading ")):
			__send_to_objm__(lmessage.substr(8).begins_with("true"), "loading")
		elif (lmessage.begins_with("singing ")):
			__send_to_objm__(lmessage.substr(8).begins_with("true"), "singing")
		elif (lmessage.begins_with("emotion ")):
			__send_to_objm__(message.substr(8).to_int(), "emotion")
		elif (lmessage == "read_chat"):
			__send_to_objm__(null, "read_chat")
		
		message = ""
		lmessage = ""
		SendMessage("done")
