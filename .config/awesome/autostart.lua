local executer = require("modules/executer")


local function setup()
    -- Autostart
    executer.execute_commands({
        "nm-applet",
        "picom -b",
        "flameshot",
        "xfce4-clipman",
    })
end


return {
    setup = setup
}
