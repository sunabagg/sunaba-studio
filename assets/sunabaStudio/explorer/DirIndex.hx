package sunabaStudio.explorer;

class DirIndex {
    public var path : String = "";
    public var dirName : String = "";

    public var directories : Array<DirIndex> = new Array<DirIndex>();

    public var files : Array<FileIndex> = new Array<FileIndex>();

    public var parent : DirIndex = null;

    public function new(path : String, parent : DirIndex = null) {
        this.path = path;
        this.dirName = path.split("/").pop();
        this.parent = parent;
    }
}