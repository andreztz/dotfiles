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

local signals = require("signals")
signals.setup()

local autostart = require("autostart")
autostart.setup()

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
