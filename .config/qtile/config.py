import subprocess
from pathlib import Path

from libqtile.bar import Bar
from libqtile.config import Click 
from libqtile.config import Drag 
from libqtile.config import Group 
from libqtile.config import Key 
from libqtile.config import Match 
from libqtile.config import Screen
from libqtile.layout import Floating
from libqtile.layout import Columns
from libqtile.layout import Max
from libqtile.lazy import lazy
from libqtile.widget import CurrentLayout
from libqtile.widget import GroupBox
from libqtile.widget import Prompt
from libqtile.widget import Chord
from libqtile.widget import TextBox
from libqtile.widget import WindowName
from libqtile.widget import Sep
from libqtile.widget import CPU
from libqtile.widget import Memory
from libqtile.widget import Volume
from libqtile.widget import Systray
from libqtile.widget import Clock
from libqtile.widget import QuickExit
from libqtile.utils import guess_terminal
from libqtile import hook


mod = "mod4"
terminal = guess_terminal()


@hook.subscribe.startup_once
def autostart():
    home = Path.home()
    subprocess.run([home.joinpath(".config/qtile/autostart.sh")])


@hook.subscribe.client_new
def assign_app_to_group(client):
    if client.name == 'pavucontrol':
        client.togroup('All')

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Move between monitors
    Key([mod], 'period', lazy.next_screen(), desc='Next monitor'),
    # Key([mod], "m", lazy.to_screen(0)),
    # Key([mod, "shift"], "m", lazy.to_screen(1)), 
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
]

# groups = [Group(i) for i in "123456789"]
groups = [
    Group("main", layout="max", matches=[Match(title="kitty")]),
    Group(
        "secondary",
        layout="column",
        matches=[
            Match(wm_class="pavucontrol"),
            Match(wm_class="firefox"),
        ]
    ),
    # Group("All", layout="column"),
]

for i, v in enumerate(groups, start=1):
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                str(i),
                lazy.group[v.name].toscreen(),
                desc="Switch to group {}".format(v.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                str(i),
                lazy.window.togroup(v.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(v.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="Font Awesome",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    # wallpaper="/path/to/your/wallpaper.png",
    # wallpaper_mode="fill",
    Screen(
        top=Bar(
            [
                CurrentLayout(),
                GroupBox(),
                Prompt(),
                WindowName(),
                Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                TextBox("default config", name="default"),
                TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                Sep(padding=6),
                CPU(),
                Sep(padding=6),
                TextBox(text="MEM", padding=1),
                Memory(),
                Sep(padding=6),
                TextBox(text="Vol", padding=1),
                Volume(),
                Sep(padding=6),
                Systray(),
                Clock(format="%Y-%m-%d %a %I:%M %p"),
                Sep(padding=6),
                QuickExit(),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
    Screen(
        top=Bar(
            [
                CurrentLayout(),
                GroupBox(),
                Prompt(),
                WindowName(),
                Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                TextBox("default config", name="default"),
                TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                Clock(format="%Y-%m-%d %a %I:%M %p"),
                QuickExit(),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

floating_layout = Floating(
    float_rules=[
        # Execute o utilitário `xprop` para ver a `wm class` e o  `name` de um client X.
        # desempacota as regras definidas na classe
        *Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
