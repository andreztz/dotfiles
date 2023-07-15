-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local vicious = require("vicious")
local executer = require("modules/executer")

local _log = require("gears.debug")

-- Exemplo de uso do sistema de log
-- _log.print_error("Exibe uma mensagem de erro!")
-- _log.print_warning("Exibe mensagem de aviso!")
--
-- Exibe uma tabela
-- _log.dump({
--     nome = "Test",
--     sobrenome = 1
-- })

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end

-- Variable definitions
HOME = os.getenv("HOME")
-- Themes define colours, icons, font and wallpapers.
beautiful.init(HOME .. "/.config/awesome/themes/" .. "ztz/theme.lua")
local launch_command = HOME .. "/.scripts/launcher.sh"
-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = "nvim" or os.getenv("EDITOR")
editor_cmd = terminal .. " -e " .. editor
awful.screen.set_auto_dpi_enabled(true)
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"


local layouts = require("layouts")
layouts.setup()

local menu = require("menu")
menu.setup()

local taskbar = require("taskbar")
taskbar.setup()

local bindings = require("bindings")
bindings.setup()

local rules = require("rules")
rules.setup()

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- -- Função auxiliar para lidar com evento de duplo clique da barra de titulo
local double_click_timer = nil -- Variável para controlar o temporizador de clique duplo
local function double_click_event_handler()
    if double_click_timer then
        -- O temporizador está ativo, portanto, ação de clique duplo é executada e
        -- finalmente o valor de retorno é true
        double_click_timer:stop()
        double_click_timer = nil
        return true
    end
    --  inicia um novo temporizador de clique duplo, caso não ativo.
    double_click_timer = gears.timer.start_new(0.20, function()
        double_click_timer = nil
        return false
    end)
end


-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            -- Verifica o tipo de evento
            if double_click_event_handler() then
                -- Maximiza ou restaura a janela, no duplo clique na barra de titulo.
                c.maximized = not c.maximized
            else
                -- Clique simples na barra de titulo, move a janela.
                awful.mouse.client.move(c)
            end
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup {
        {
            -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        {
            -- Middle
            {
                -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        {
            -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Autostart
-- TODO: encontrar um nome melhor para executor e execute_commands, talvez subprocess.run_once ou autostart.run...
executer.execute_commands({
    "nm-applet",
    "picom -b",
    "flameshot",
    -- "xfce4-clipman", -- TODO: se o ambinete for xfce4 não executar
})


-- -- Signal function to execute when a new client appears.
-- client.connect_signal("manage", function (c)
--   -- Set the windows at the slave,
--   -- i.e. put it at the end of others instead of setting it master.
--   -- if not awesome.startup then awful.client.setslave(c) end
--
--  if awesome.startup and
--   not c.size_hints.user_position
--   and not c.size_hints.program_position then
--     -- Prevent clients from being unreachable after screen count changes.
--     awful.placement.no_offscreen(c)
--  end
-- --
--  awful.titlebar(c,{size=20})
--  -- awful.titlebar.hide(c)
-- end)
