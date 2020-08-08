--[[

   ___       ___       ___       ___       ___       ___       ___
  /\  \     /\__\     /\  \     /\  \     /\  \     /\__\     /\  \
 /::\  \   /:/\__\   /::\  \   /::\  \   /::\  \   /::L_L_   /::\  \
/::\:\__\ /:/:/\__\ /::\:\__\ /\:\:\__\ /:/\:\__\ /:/L:\__\ /::\:\__\
\/\::/  / \::/:/  / \:\:\/  / \:\:\/__/ \:\/:/  / \/_/:/  / \:\:\/  /
  /:/  /   \::/  /   \:\/  /   \::/  /   \::/  /    /:/  /   \:\/  /
  \/__/     \/__/     \/__/     \/__/     \/__/     \/__/     \/__/

-- >> The file that binds everything together.
--]]

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

-- Features
-- ===================================================================
-- Initialize icons array and load icon theme
--local icons = require("icons")
--icons.init("drops")
-- Load notification daemons and notification theme
--local notifications = require("notifications")
--notifications.init("amarena")

-- >> Daemons
-- Most widgets that display system/external info depend on evil.
-- Make sure to initialize it last in order to allow all widgets to connect to
-- their needed evil signals.
require("evil.brightness")

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err) })
        in_error = false
    end)
end

-- }}}

-- {{{ Variable definitions

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
local xrdb = beautiful.xresources.get_current_theme()
-- Make dpi function global
dpi = beautiful.xresources.apply_dpi
-- Make xresources colors global
x = {
    --           xrdb variable
    background = xrdb.background,
    foreground = xrdb.foreground,
    color0     = xrdb.color0,
    color1     = xrdb.color1,
    color2     = xrdb.color2,
    color3     = xrdb.color3,
    color4     = xrdb.color4,
    color5     = xrdb.color5,
    color6     = xrdb.color6,
    color7     = xrdb.color7,
    color8     = xrdb.color8,
    color9     = xrdb.color9,
    color10    = xrdb.color10,
    color11    = xrdb.color11,
    color12    = xrdb.color12,
    color13    = xrdb.color13,
    color14    = xrdb.color14,
    color15    = xrdb.color15,
}

beautiful.wallpaper = os.getenv("HOME") .. "/.config/awesome/assets/wallpaper.jpg"
beautiful.useless_gap = dpi(5)
beautiful.screen_margin = dpi(5)
beautiful.taglist_font = "awesomewm-font 13"

-- This is used later as the default terminal and editor to run.
terminal = os.getenv("TERMINAL") or "kitty"
filemanager = os.getenv("FILEMANAGER") or "kitty --class files -e nnn"
browser = os.getenv("BROWSER") or "firefox"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- >> Web Search <<
web_search_cmd = "xdg-open https://duckduckgo.com/?q="
-- web_search_cmd = "xdg-open https://www.google.com/search?q=",

-- >> User profile <<
profile_picture = os.getenv("HOME").."/.config/awesome/assets/profile.png"

-- Directories with fallback values
dirs = {
    downloads = os.getenv("XDG_DOWNLOAD_DIR") or "~/Downloads",
    documents = os.getenv("XDG_DOCUMENTS_DIR") or "~/Documents",
    music = os.getenv("XDG_MUSIC_DIR") or "~/Music",
    pictures = os.getenv("XDG_PICTURES_DIR") or "~/Pictures",
    videos = os.getenv("XDG_VIDEOS_DIR") or "~/Videos",
    -- Make sure the directory exists so that your screenshots
    -- are not lost
    screenshots = os.getenv("XDG_SCREENSHOTS_DIR") or "~/Pictures/Screenshots",
}

-- >> Sidebar <<
sidebar = {
    hide_on_mouse_leave = true,
    show_on_mouse_screen_edge = true,
}

-- >> Battery <<
-- You will receive notifications when your battery reaches these
-- levels.
battery_threshold_low = 20
battery_threshold_critical = 5

-- >> Coronavirus <<
-- Country to check for corona statistics
-- Uses the https://corona-stats.online API
coronavirus_country = "india"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Other Keys
altkey = "Mod1"
ctrlkey = "Control"
shiftkey = "Shift"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

-- }}}

-- {{{ Menu

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- }}}

-- {{{ Wibar

-- Create a textclock widget
mytextclock = wibox.widget.textclock()
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

require("elements.bar")

-- }}}

-- {{{ Keys

local keys = require("utils.keys")

-- }}}

-- {{{ Rules

local rules = require("utils.rules")
rules:init(keys.clientkeys, keys.clientbuttons)

-- }}}

-- {{{ Signals

require("utils.signals")

-- }}}

-- Garbage collection
-- Enable for lower memory consumption
-- ===================================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- {{{ Autostart Scripts

awful.spawn.with_shell("sh ~/.config/awesome/scripts/autorun.sh")

-- }}}
