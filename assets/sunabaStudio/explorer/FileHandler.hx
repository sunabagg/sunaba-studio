package sunabaStudio.explorer;

import sunabaStudio.EditorWidget;
import sunabaStudio.Explorer;

class FileHandler {
    public var extension : String = "";

    public var iconPath : String = "";

    public var explorerObj : Explorer = null;

    public var widget : EditorWidget = null;

    public function new(w : EditorWidget, e : Explorer) {
        widget = w;
        explorerObj = e;

        init();
    }

    public function init() {}

    public function openFile(path : String) {}
}