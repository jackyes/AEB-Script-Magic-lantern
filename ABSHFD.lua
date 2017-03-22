--[[ 	
18/03/2017
	@ToDo:
	Menu
--]]

--[[ 
	Focus bracketing and exposure bracketing script
--]]

keymenu = menu.new
{
    name   = "Start AEBHFD!",
    help   = "Start AEB script.",
    select = function(this) task.create(main) end,
}

function main()
    menu.close()
	display.notify_box("Starting....", 1000)
 	if lens.focus_distance > lens.hyperfocal then
		display.notify_box("FP > HFD", 2000)
	elseif lens.dof_far == lens.dof_near then
		--THANKS to grayheron!!
		display.notify_box("Check ML setting for CoC", 2000)
	elseif math.abs(lens.dof_near-lens.dof_far) < 10 then 
		--THANKS to grayheron!!
		-- adjust this test to your taste (default is 10mm)
		-- the above test is there to handle long FL cases, as the DoF.near and Dof.far may be too close together
		-- which can throw out the script.
		-- So don't use a long lens ;-)
	display.notify_box("Warning: Change lens FL or focus point", 2000)
	else
		AutoCalc()
		TakeBlackFrame()
	end
end

function TakeBlackFrame()  --Put a black frame at the and of bracketed image
		--Store the tv,av and iso value.
		local tv = camera.shutter.ms
		local av = camera.aperture.value 
		local iso = camera.iso.value
		
		--Set very low tv, max av and low iso. We absolutly want a black frame :)
		camera.shutter.ms = 1
		camera.aperture.apex = camera.aperture.max.apex
		camera.iso.value = 100
		
		--Take the black shoot
		camera.shoot(64,false)
		
		--Reset tv,av and iso old value
		camera.shutter.ms = tv
		camera.aperture.value = av
		camera.iso.value = iso
end

function AutoCalc()
    local target = lens.dof_far

    takeshoot()  --First photo at user select (first) focus plane

    while true do
        if lens.focus_distance > lens.hyperfocal then
			repeat lens.focus(1,1,false) until lens.focus_distance <= lens.hyperfocal
			takeshoot()
            break
        end
		
		repeat lens.focus(-1,2,false) until lens.dof_near >= target   --move the min dof focus point of the next photo to the max dof of old photo
		if lens.dof_near > target then
			repeat lens.focus(1,1,false) until lens.focus_distance <= target	--return to make the FP more fine
		end
        target = lens.dof_far
        takeshoot()
    end
end

function takeshoot()
	local shutterok = camera.shutter.value
    console.show()
    print("first shot at %s", camera.shutter.ms)
    msleep(1000)
    shoot (64,false)
    msleep(2000)
    camera.shutter.value = shutterok * 4
    print("second shot at 2EV %s", camera.shutter.ms)
    msleep(1000)
    shoot (64,false)
    camera.shutter.value = shutterok / 4
    print("second shot at -2EV %s", camera.shutter.ms)
    msleep(1000)
    shoot (64,false)
    camera.shutter.value = shutterok
    console.hide()
end