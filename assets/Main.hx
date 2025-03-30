import sunaba.App;
import sunabaStudio.EditorWidget;

class Main extends App{
    public var editorWindow : EditorWidget;

    public static function main(){
        new Main();
    }

    public override function init() {
        editorWindow = new EditorWidget(ioInterface, rootNode);
    }
}