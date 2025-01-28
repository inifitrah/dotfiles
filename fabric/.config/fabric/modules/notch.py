from os import truncate
from fabric.widgets.box import Box
from fabric.widgets.label import Label
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.button import Button
from fabric.widgets.stack import Stack
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.hyprland.widgets import ActiveWindow
from fabric.utils.helpers import FormattedString, truncate, get_relative_path
from gi.repository import GLib, Gdk
from modules.dashboard import Dashboard
from modules.power import PowerMenu

from modules.corners import MyCorner
import modules.icons as icons
import modules.data as data

class Notch(Window):
    def __init__(self, **kwargs):
        super().__init__(
            name="notch",
            layer="top",
            anchor="top",
            margin="-40px 10px 10px 10px",
            keyboard_mode="none",
            exclusivity="normal",
            visible=True,
            all_visible=True,
        )

        self.power = PowerMenu()
        self.dashboard = Dashboard()

        self.active_window = ActiveWindow(
            name="hyprland-window",
            h_expand=True,
            formatter=FormattedString(
                f"{{'{data.USERNAME}@{data.HOSTNAME}' if not win_title else truncate(win_title, 30)}}",
                truncate=truncate,
            ),
        )

        self.compact = Button(
            name="notch-compact",
            h_expand=True,
            on_clicked=lambda *_: self.open_notch("dashboard"),
            child=self.active_window,
        )

        self.stack = Stack(
            name="notch-content",
            v_expand=True,
            h_expand=True,
            transition_type="crossfade",
            transition_duration=250,
            children=[
                self.compact,
                self.dashboard,
                self.power
            ]
        )

        self.corner_left = Box(
            name="notch-corner-left",
            orientation="v",
            children=[
                MyCorner("top-right"),
                Box(),
            ]
        )

        self.corner_right = Box(
            name="notch-corner-right",
            orientation="v",
            children=[
                MyCorner("top-left"),
                Box(),
            ]
        )

        self.notch_box = CenterBox(
            name="notch-box",
            orientation="h",
            h_align="center",
            v_align="center",
            start_children=Box(
                children=[
                    Box(
                        name="button-media-box",
                        orientation="v",
                        v_expand=True,
                        children=[
                            # self.button,
                            Box(v_expand=True),
                        ],
                    ),
                    self.corner_left,
                ],
            ),
            center_children=self.stack,
            end_children=Box(
                children=[
                    self.corner_right,
                    Box(
                        name="button-color-box",
                        orientation="v",
                        v_expand=True,
                        children=[
                            # self.button,
                            Box(v_expand=True),
                        ],
                    )
                ]
            )
        )

        self.hidden = False

        self.add(self.notch_box)
        self.show_all()

        self.add_keybinding("Escape", lambda *_: self.close_notch())
        self.add_keybinding("Ctrl Tab", lambda *_: self.dashboard.go_to_next_child())
        self.add_keybinding("Ctrl Shift ISO_Left_Tab", lambda *_: self.dashboard.go_to_previous_child())

    def on_button_enter(self, widget, event):
        window = widget.get_window()
        if window:
            window.set_cursor(Gdk.Cursor(Gdk.CursorType.HAND2))

    def on_button_leave(self, widget, event):
        window = widget.get_window()
        if window:
            window.set_cursor(None)

    def close_notch(self):
        self.set_keyboard_mode("none")

        if self.hidden:
            self.notch_box.remove_style_class("hideshow")
            self.notch_box.add_style_class("hidden")

        for widget in [self.dashboard, self.power]:
            widget.remove_style_class("open")
        for style in ["dashboard", "power"]:
            self.stack.remove_style_class(style)
        self.stack.set_visible_child(self.compact)

    def open_notch(self, widget):
        self.set_keyboard_mode("exclusive")

        if self.hidden:
            self.notch_box.remove_style_class("hidden")
            self.notch_box.add_style_class("hideshow")

        widgets = {
            "dashboard": self.dashboard,
            "power": self.power
        }

        # Clear previous classes and states
        for style in widgets.keys():
            self.stack.remove_style_class(style)
        for w in widgets.values():
            w.remove_style_class("open")
        
        # Add specific actions for each widget if needed
        if widget in widgets:
            self.stack.add_style_class(widget)
            self.stack.set_visible_child(widgets[widget])
            widgets[widget].add_style_class("open")
            
            # Actions for each widget

        else:
            self.stack.set_visible_child(self.dashboard)

    def on_button_clicked(self, *args):
         # GLib.spawn_command_line_async("notify-send 'Button pressed' 'Success!'")
        GLib.spawn_command_line_async("notify-send 'Tombol ditekan' 'berhasil!'")

    def toggle_hidden(self):
        self.hidden = not self.hidden
        if self.hidden:
            self.notch_box.add_style_class("hidden")
        else:
            self.notch_box.remove_style_class("hidden")
