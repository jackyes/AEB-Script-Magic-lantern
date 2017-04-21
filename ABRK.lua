keymenu = menu.new
{
    name   = "Take Bracket!",
    help   = "Bracket script.(Tv)",
    select = function(this) task.create(main) end,
}

function main()
    	local shutterok = camera.shutter.value
    	console.show()
    	console.clear()
    	print("First shot at %s", camera.shutter.ms)
    	msleep(750)
    	shoot(64,false)
    	msleep(750)
    	camera.shutter.value = shutterok * 4
    	console.clear()
    	print("Second shot at 2EV %s", camera.shutter.ms)
    	msleep(750)
    	shoot(64,false)
    	msleep(750)
    	camera.shutter.value = shutterok / 4
    	console.clear()
    	print("Third shot at -2EV %s", camera.shutter.ms)
    	msleep(750)
    	shoot(64,false)
    	camera.shutter.value = shutterok
    	console.hide()	
end
