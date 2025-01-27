from fabric.widgets.box import Box
from fabric.widgets.datetime import DateTime
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.hyprland.widgets import Workspaces, WorkspaceButton
from gi.repository import GLib, Gdk

class Bar(Window):
    def __init__(self, **kwargs):
        super().__init__(
            name="bar",
            layer="top",
            anchor="left top right",
            margin="-8px -4px -8px -4px",
            exclusivity="auto",
            visible=True,
            all_visible=True,
        )
        
        self.workspaces = Workspaces(
            name="workspaces",
            invert_scroll=True,
            empty_scroll=True,
            v_align="fill",
            orientation="h",
            spacing=10,
            buttons=[WorkspaceButton(id=i, label="") for i in range(1, 11)],
        )

        self.date_time = DateTime(name="date-time", formatters=["%H:%M"], h_align="center", v_align="center")
        
        self.bar_inner = CenterBox(
            name="bar-inner",
            orientation="h",
            h_align="fill",
            v_align="center",
            start_children=Box(
                name="start-container",
                spacing=4,
                orientation="h",
                children=[
                    Box(name="workspaces-container", children=[self.workspaces]),
                ]
            ),
            end_children=Box(
                name="end-container",
                spacing=4,
                orientation="h",
                children=[
                    self.date_time,
                ],
            ),
        )

        self.children = self.bar_inner

        self.hidden = False

        self.show_all()

    def on_button_enter(self, widget, event):
        window = widget.get_window()
        if window:
            window.set_cursor(Gdk.Cursor(Gdk.CursorType.HAND2))

    def on_button_leave(self, widget, event):
        window = widget.get_window()
        if window:
            window.set_cursor(None)

    def on_button_clicked(self, *args):
        # Execute notify-send when the button is clicked
        GLib.spawn_command_line_async("notify-send 'Button Pressed' 'It works!'")

    def toggle_hidden(self):
        self.hidden = not self.hidden
        if self.hidden:
            self.bar_inner.add_style_class("hidden")
        else:
            self.bar_inner.remove_style_class("hidden")
