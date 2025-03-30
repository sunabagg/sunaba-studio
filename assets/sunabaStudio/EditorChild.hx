package sunabaStudio;

import sunaba.godot.Node;
import sunaba.io.IoInterface;
import sunaba.ui.Widget;

class EditorChild extends Widget {
    public var parent : EditorWidget;

    public function new(parent : EditorWidget, parentNode : Node) {
        this.parent = parent;
        parent.children.push(this);
        super(parent.ioInterface, parentNode);
    }
}