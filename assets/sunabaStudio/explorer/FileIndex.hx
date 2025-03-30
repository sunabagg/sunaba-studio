package sunabaStudio.explorer;

class FileIndex {
    public var path : String = "";
    public var fileName : String = "";

    public var parent : DirIndex = null;

    public function new(path : String, parent : DirIndex = null) {
        this.path = path;
        this.fileName = path.split("/").pop();
        this.parent = parent;
    }
}