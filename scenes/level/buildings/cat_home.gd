@tool

extends "res://scenes/level/buildings/base_building.gd"

func _ready():
    if not Engine.is_editor_hint():
        update_label()
    
    interaction_area.body_entered.connect(_on_body_entered_interact)

func update_label():
    #print(MapData.building_data)
    var data = MapData.building_data.get(get_tile_position())
    if data == null:
        push_error("Building data not found for building at position %s" % get_tile_position())
        return
    
    var padded_address = str(data.address).pad_zeros(6)
    $%AddressLabel.text = "Singapurr Residence\n#%s" % padded_address

func get_building_data(id: int) -> BuildingData:
    var data: BuildingDataDestination = building_data.duplicate()
    data.address = id
    data.building_name = "%s #%d" % [data.building_name, data.address]
    print(data.building_name)
    return data

func _on_body_entered_interact(body: Node) -> void:
    if body.is_in_group("player"):
        print("in group")
        var tasks_panel: TasksPanel = body.tasks_panel
        for task in tasks_panel.tasks:
            print(task.destination)
            print("Name: ", building_data.building_name)
            var real_data: BuildingData
            real_data = MapData.building_data[get_tile_position()]
            if task.destination == real_data.building_name:
                print("Destination matches")
                if InventoryItems.blahajs >= task.quantity:
                    print("Sufficient funds")
                    InventoryItems.blahajs -= task.quantity
                    tasks_panel.remove_task(task)
