package sunabaStudio.explorer.fileHandlers;

import sunabaStudio.explorer.FileHandler;
import sunabaStudio.codeEditor.CodeEditorWidget;
import sunabaStudio.codeEditor.HaxePlugin;

class HxFileHandler extends FileHandler {

    override function init() {
        extension = ".hx";
        iconPath = "app://FugueIcons/icons/script-code.png";
    }

    override function openFile(path : String) {
        Sys.println("open file: " + path);

        var codeEditorWidget = new CodeEditorWidget(widget, widget.contentView);
        codeEditorWidget.openFile(path, new HaxePlugin());
        var icon = explorerObj.loadIcon(iconPath);
        codeEditorWidget.parent.contentView.setTabIcon(codeEditorWidget.document.getIndex(), icon);
    }
}