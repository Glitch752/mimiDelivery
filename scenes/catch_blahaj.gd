extends Control

var blahajCooked = false
var rng = RandomNumberGenerator.new()
var randKey = 0
var catchString = "catchP"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    rng.randomize()
    randKey = rng.randi_range(0,3)
    if randKey == 0:
        catchString = "catchP"
        $Label2.text = "Press P to catch"
    elif randKey == 1:
        catchString = "catchZ"
        $Label2.text = "Press Z to catch"
    elif randKey == 2:
        catchString = "catchJ"
        $Label2.text = "Press J to catch"
    else:
        catchString = "catchG"
        $Label2.text = "Press G to catch"
    $Timer.wait_time = 5
    $Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var pressed = Input.is_action_just_pressed(catchString)
    if pressed and blahajCooked:
        print("caught")
        InventoryItems.blahajs += 1
        visible = false
    elif pressed:
        var newWaitTime = $Timer.time_left-1
        $Timer.stop()
        $Timer.wait_time = newWaitTime
        $Timer.start()
        print("not caught")
    $ProgressBar.value = $Timer.time_left

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.is_in_group("blahaj"):
        blahajCooked = true


func _on_area_2d_body_exited(body: Node2D) -> void:
    if body.is_in_group("blahaj"):
        blahajCooked = false


func _on_timer_timeout() -> void:
    visible = false
