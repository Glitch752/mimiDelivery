@tool

extends "res://scenes/level/buildings/base_building.gd"

@export var address: int = 0

func _ready():
    update_label()

func update_label():
    var padded_address = str(address).pad_zeros(6)
    $%AddressLabel.text = "Singapurr Residence\n#%s" % padded_address

func set_address(addr: int):
    address = addr
    update_label()
