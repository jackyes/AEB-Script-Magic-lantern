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
            help = "Ev bracket 0 - 5 range. Default: 2",
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
	console.hide()
	--Somthing will happen here! ;)
	-- EC for the bracket. AEBMenu.submenu["Ev Bracket"].value
	TakeBlackFrame() --Last thing to do
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

