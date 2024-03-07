import logging
import os
import gi
import netifaces

import subprocess
gi.require_version("Gtk", "3.0")
from gi.repository import GLib, Gtk, Pango, Gdk, GdkPixbuf

from ks_includes.screen_panel import ScreenPanel

def create_panel(*args):
    return PlrPanel(*args)

class PlrPanel(ScreenPanel):
    def __init__(self, screen, title):
        super().__init__(screen, title)
        # 设置按钮的 CSS 样式
        # self.style_provider = Gtk.CssProvider()
        # self.style_provider.load_from_data('''
        #     .button_cancel {
        #         background-color: #747f85;
        #     }
        # '''.encode())
        self.dialog_out()

    def dialog_out(self):
        self.fixed = Gtk.Fixed()
        self.fixed.set_size_request(480, 800)
        self.image = Gtk.Image()
        home_dir = os.path.expanduser("~")
        self.image.set_from_file(home_dir + "/KlipperScreen/styles/plr_back.png")
        # self.fixed.put(self.image, 0, 0)
        # self._screen.add(self._screen.plr.fixed)

        # 创建内层的固定布局容器
        self.inner_fixed = Gtk.Fixed()
        self.inner_fixed.set_size_request(400, 320)
        # 解析色号为 Gdk.Color 对象
        # color = Gdk.RGBA()
        # color.parse("#747f85")

        # 设置内层容器的背景颜色
        # self.inner_fixed.override_background_color(Gtk.StateType.NORMAL, color)  # 使用红色作为背景颜色
        self.inner_fixed.add(self.image)
        
        # self.fixed.put(self.image, 40, 240)
        # 创建一个 cancel image 控件
        # self.image_cancel = Gtk.Image()
        # self.pixbuf_cancel = GdkPixbuf.Pixbuf.new_from_file_at_size(home_dir + "/KlipperScreen/styles/plr-cancel.svg")
        # self.image_cancel.set_from_pixbuf(self.pixbuf_cancel)
        # self.btn_cancel = self._gtk.Button("arrow-left",_("Cancel"), f"color4")
        self.btn_cancel = Gtk.Button(label="Cancel")
        self.btn_cancel.get_style_context().add_class("button_cancel")
        # self.btn_cancel.add(self.image_cancel)
        # self.btn_cancel = self._gtk.Button("plr-cancel", _("Cancel"), f"color3")
        self.btn_cancel.set_size_request(160, 60)
        self.btn_cancel.connect('clicked', self.cancel)
        
        # self.label_tips = Gtk.Label()
        self.btn_ok = Gtk.Button(label="OK")
        self.btn_ok.get_style_context().add_class("button_ok")
        # self.btn_ok = self._gtk.Button("plr-okay", _("Ok"), f"color3")
        self.btn_ok.set_size_request(160, 60)
        self.btn_ok.connect("clicked", self.okay)

        self.text_tips = _("Abnormal interruption\n of printing is detected,\nwhether to resume")
        self.label_tips = Gtk.Label()
        # self.label_tips.set_line_wrap(True)
        self.label_tips.set_justify(Gtk.Justification.CENTER)
        self.label_tips.set_markup("<span font='DejaVu Sans 20'>{}</span>".format(self.text_tips))
        
        # self.label_tips.set_text(_("Abnormal interruption of printing is detected, whether to resume"))
        # self.label_tips.set_halign(Gtk.Align.CENTER)
        # self.label_tips.set_line_wrap(True)
        # self.label_tips.set_justify(Gtk.Justification.CENTER)
        # self.label_tips.set_markup("<span font='DejaVu Sans 20'>{}</span>".format(self.text_tips))
        # self.box_tips = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        # self.box_tips.set_halign(Gtk.Align.CENTER)
        # self.box_tips.set_size_request(320, 240)
        # self.box_tips.pack_start(self.text_tips, False, False, 10)

        self.inner_fixed.put(self.btn_cancel, 40, 240)
        self.inner_fixed.put(self.btn_ok, 200, 240)
        self.inner_fixed.put(self.label_tips, 40, 80)
        # label_tips_text = "Abnormal interruption of printing is detected, whether to resume"
        self.fixed.put(self.inner_fixed, 40, 60)


    def okay(self, widget):
        self._screen._ws.klippy.gcode_script(f"resume_interrupted")
        logging.info("Okay, 开始断电续打")
        self._screen.remove(self.fixed)
        self._screen.add(self._screen.base_panel.main_grid)
        self._screen.show_all()
        
    def cancel(self, widget):
        self._screen._ws.klippy.gcode_script(f"clear_last_file")
        self._screen._ws.klippy.gcode_script(f"SAVE_VARIABLE VARIABLE=was_interrupted VALUE=False")
        self._screen._ws.klippy.gcode_script(f"RUN_SHELL_COMMAND CMD=clear_plr")
        self._screen.plr_bool = "False"
        self._screen.remove(self.fixed)
        self._screen.add(self._screen.base_panel.main_grid)
        # self._screen.show_all()
        # self._screen._remove_all_panels()
        self._screen.show_panel("main_menu", None, remove_all=True, items=self._config.get_menu_items("__main"))
        self._screen.base_panel_show_all()

