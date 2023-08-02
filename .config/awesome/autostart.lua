local executer = require("modules/executer")


local function setup()
    -- Autostart
    executer.execute_commands({
        "xcompmgr",
        "flameshot",
        "volumeicon",
        "nm-applet",
        "xfce4-clipman",
    })
end


return {
    setup = setup
}
