package sunabaStudio.codeEditor;

import sunaba.godot.CodeEdit;
import sunabaStudio.EditorChild;

class CodeEditorWidget extends EditorChild {
    public var path : String;

    public var codeEdit : CodeEdit;

    public var plugin : CodeEditorPlugin;

    override function init() {
        document.load("app://sunabaStudio/codeEditor/CodeEditorWidget.xml");
        codeEdit = cast document.getObject("VBoxContainer/CodeEditControl/CodeEdit");
    }

    public function openFile(path : String, plugin : CodeEditorPlugin) {
        this.path = path;
        var fileName = path.split("/").pop();
        var index = document.getIndex();
        parent.contentView.setTabTitle(index, fileName);

        var code = ioInterface.loadText(path);
        codeEdit.text = code;
        codeEdit.clearUndoHistory();

        this.plugin = plugin;
        plugin.widget = this;
        plugin.init();
    }
}