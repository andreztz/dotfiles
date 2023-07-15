local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

local function setup()
    -- Cria menu de execução de aplicativos
    awesome_menu = {
        { "hotkeys",     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
        { "manual",      terminal .. " -e man awesome" },
        { "edit config", editor_cmd .. " " .. awesome.conffile },
        { "restart",     awesome.restart },
        { "quit",        function() awesome.quit() end },
    }

    main_menu = awful.menu({
        items = { { "awesome", awesome_menu, beautiful.awesome_icon },
            { "open terminal", terminal }
        }
    })

    menu_launcher = awful.widget.launcher({
        image = beautiful.awesome_icon,
        menu = main_menu
    })

    -- Menubar configuration
    menubar.utils.terminal = terminal -- Set the terminal for applications that require it

end


return {
    setup = setup
}
