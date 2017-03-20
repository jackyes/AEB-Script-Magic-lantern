AEBMenu = menu.new
{
    parent = "Debug",
    name = "AEB",
    help = "AEB Script",
    submenu =
    {
        {
            name = "Run",
            help = "Start AEB Script.",
			help2 = "Leave it work and take a coffe. :)",
        },

        {
            name = "Ev Bracket",
            help = "If Ev Bracket is lower or equal 3, take 3 photo.",
			help2 = "If Ev Bracket is higher than 3, make 5 photo."
            min = 0,
            max = 5,
            value = 2
        },
        {
            name = "FinishBlackFrame",
			help = "Black shoot at the end.",
            choices = { "Yes", "No" },
        },

    },
}

AEBMenu.submenu["Run"].select = function(this)
    console.show()
	print("[---]Hi, AEB is Starting...[---]")
	msleep(1000)
	FocusStack()
	TakeBlackFrame() --Last thing to do
	print("[---]Bye. Done[---]")
	console.hide()
end


function TakeBlackFrame()  --Put a black frame at the and of bracketed image
	if AEBMenu.submenu["FinishBlackFrame"].value == "Yes" then
		--Store the tv,av and iso value.
		local tv = camera.shutter.ms
		local av = camera.aperture.value 
		local iso = camera.iso.value
		
		--Set very low tv, max av and low iso. We absolutly want a black frame :)
		camera.shutter.ms = 1
		camera.aperture.apex = camera.aperture.min.apex
		camera.iso.value = 100
		
		--Take the black shoot
		camera.shoot(false)
		
		--Reset tv,av and iso old value
		camera.shutter.ms = tv
		camera.aperture.value = av
		camera.iso.value = iso
	end
end

function FocusStack()
    local target = lens.dof_far

    takeshoot()  --First photo at user select (first) focus plane

    while true do
        if lens.focus_distance >= lens.hyperfocal then
            break
        end
        repeat
	        lens.focus(-1,2,false)
	    until lens.dof_near >= target   --move the min dof focus point of the next photo to the max dof of old photo
        target = lens.dof_far
        takeshoot()
    end

end

function takeshoot()
local EC = AEBMenu.submenu["Ev Bracket"].value
local shutterok = camera.shutter.value
    console.show()
    print("First shoot at 0EC", camera.shutter.value)
    msleep(500)
    shoot (64,false)
	if EC ~= 0 then
		if EC = 4 then
			camera.shutter.value = shutterok * 2^(EC - 2)
			print("Shoot at +2EV")
			msleep(500)
		end
		if EC = 5 then
			camera.shutter.value = shutterok * 2^(EC - 3)
			print("Shoot at +2EV")
			msleep(500)
		end
		camera.shutter.value = shutterok * 2^EC
		print("Shoot at +" .. EC .. "EV ")
		msleep(500)
		shoot (64,false)
		
		if EC = 4 then
			camera.shutter.value = shutterok / 2^(EC - 2)
			print("Shoot at -2EV")
			msleep(500)
		end
		if EC = 5 then
			camera.shutter.value = shutterok / 2^(EC - 3)
			print("Shoot at -2EV")
			msleep(500)
		end
		camera.shutter.value = shutterok / 2^EC
		print("second shot at -" .. EC .. "EV")
		msleep(500)
		shoot (64,false)
		camera.shutter.value = shutterok
	end
    console.hide()
end
