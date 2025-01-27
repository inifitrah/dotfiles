import setproctitle
from fabric import Application
from fabric.utils import get_relative_path
from modules.bar import Bar
from modules.notch import Notch

if __name__ == "__main__":
    setproctitle.setproctitle("trah-shell")
    bar = Bar()
    notch = Notch() 
    app = Application("trah-shell", bar, notch)
    app.set_stylesheet_from_file(get_relative_path("main.css"))
    app.run()