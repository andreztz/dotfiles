local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local vicious = require("vicious")


local function setup()
    -- Keyboard map indicator and switcher
    local mykeyboardlayout = awful.widget.keyboardlayout()

    -- Wibar
    -- Create a textclock widget
    local mytextclock = wibox.widget.textclock()

    -- Create System Tray widget 
    -- see: https://github.com/awesomeWM/awesome/issues/971
    local systray_widget = wibox.widget.systray()
    systray_widget:set_reverse(true)

    local systray_wrapper = wibox.widget {
        {
            systray_widget,
            left = 10,
            top = 2,
            bottom = 2,
            right = 10,
            widget = wibox.container.margin,
        },
        --bg = "#ff0000aa", -- uncomment to debug
        -- shape = gears.shape.rounded_rect,
        shape_clip = true,
        widget = wibox.container.background,
    }
    -- local systray_wrapper = wibox.widget.systray()
    -- systray_wrapper:set_reverse(true)

    memwidget = wibox.widget.textbox()
    vicious.cache(vicious.widgets.mem)
    vicious.register(memwidget, vicious.widgets.mem, "$1 ($2MiB/$3MiB)", 13)

    -- Create a wibox for each screen and add it
    local taglist_buttons = gears.table.join(
        awful.button({}, 1, function(t) t:view_only() end),
        awful.button({ modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
        awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
    )

    local tasklist_buttons = gears.table.join(
        awful.button({}, 1, function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal(
                    "request::activate",
                    "tasklist",
                    { raise = true }
                )
            end
        end),
        awful.button({}, 3, function()
            awful.menu.client_list({ theme = { width = 250 } })
        end),
        awful.button({}, 4, function()
            awful.client.focus.byidx(1)
        end),
        awful.button({}, 5, function()
            awful.client.focus.byidx(-1)
        end))

    local function set_wallpaper(s)
        -- Wallpaper
        if beautiful.wallpaper then
            local wallpaper = beautiful.wallpaper
            -- If wallpaper is a function, call it with the screen
            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end
            gears.wallpaper.maximized(wallpaper, s, true)
        end
    end

    -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
    screen.connect_signal("property::geometry", set_wallpaper)

    awful.screen.connect_for_each_screen(function(s)
        -- [ ] - Resolver problema de iniciar o System Tray
        --       somente no monitor primario ou monitor escolhido.

        -- Pelos meus testes s.index == 2 não resolver o problema do system tray
        if s.index == 1 then
            s.primary = true
        else
            s.primary = false
        end

        -- Wallpaper
        -- set_wallpaper(s)

        -- Each screen has its own tag table.
        awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" },
            s, awful.layout.layouts[1]
        )

        -- Create a promptbox for each screen
        s.mypromptbox = awful.widget.prompt()
        -- Create an imagebox widget which will contain an icon indicating which layout we're using.
        -- We need one layoutbox per screen.
        s.mylayoutbox = awful.widget.layoutbox(s)
        s.mylayoutbox:buttons(gears.table.join(
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(1) end),
            awful.button({}, 5, function() awful.layout.inc(-1) end)))
        -- Create a taglist widget
        s.mytaglist = awful.widget.taglist {
            screen  = s,
            filter  = awful.widget.taglist.filter.all,
            buttons = taglist_buttons
        }
        -- Create a tasklist widget
        s.mytasklist = awful.widget.tasklist {
            screen  = s,
            filter  = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons
        }
        -- Create the wibox
        s.mywibox = awful.wibar({
            position = "top",
            screen = s,
            opacity = .8,
            type = "desktop",
        })

        -- Add widgets to the wibox
        if (s.primary) then
            s.mywibox:setup {
                layout = wibox.layout.align.horizontal,
                {
                    -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                    menu_launcher,
                    s.mytaglist,
                    s.mypromptbox,
                },
                s.mytasklist, -- Middle widget
                {
                    -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    systray_wrapper,
                    mytextclock,
                    s.mylayoutbox,
                },
            }
        else
            s.mywibox:setup {
                layout = wibox.layout.align.horizontal,
                {
                    -- Left widgets
                    layout = wibox.layout.fixed.horizontal,
                    menu_launcher,
                    s.mytaglist,
                    s.mypromptbox,
                },
                s.mytasklist, -- Middle widget
                {
                    -- Right widgets
                    layout = wibox.layout.fixed.horizontal,
                    mytextclock,
                    s.mylayoutbox,
                },
            }

        end

    end)

end

return {
    setup = setup
}
