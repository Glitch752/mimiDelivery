@tool
class_name J8
extends BaseBuilding


func _ready():
    super._ready()
    
    interaction_area.body_entered.connect(_on_body_entered_interact)


func _on_body_entered_interact(body: Node) -> void:
    if body.is_in_group("player"):
        var tasks_panel: TasksPanel = body.tasks_panel
        for task in tasks_panel.tasks:
            var real_data: BuildingData
            real_data = MapData.building_data[get_tile_position()]
            if task.destination == real_data.building_name:
                if InventoryItems.has_item(task.item_req, task.quantity):
                    InventoryItems.gain_item(task.item_req, -task.quantity)
                    tasks_panel.remove_task(task)
