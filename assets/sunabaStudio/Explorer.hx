package sunabaStudio;

import sunaba.godot.Control;
import sunaba.godot.OS;
import sunaba.godot.NodePath;
import sunaba.core.LuaEvent;
import sunaba.godot.Variant;
import sunaba.ToVariant;
import sunaba.godot.Vector2i;
import sunaba.godot.Vector2;
import sunaba.godot.Button;
import sunaba.godot.MenuButton;
import sunaba.godot.Tree;
import sunaba.godot.TreeItem;
import sunaba.godot.ItemList;
import sunaba.godot.ImageTexture;
import sunaba.godot.Image;
import sunabaStudio.explorer.DirIndex;
import sunabaStudio.explorer.FileIndex;
import sunabaStudio.explorer.FileHandler;
import sunaba.godot.AcceptDialog;
import sunaba.godot.GdVector2i;
import sunaba.io.IoInterface;
import lua.Table;

class Explorer {
    public var editorWidget : EditorWidget;

    public var ioInterface : IoInterface;

    public var backButton : Button;

    public var forwardButton : Button;

    public var upButton : Button;

    public var refreshButton : Button;

    public var newButton : MenuButton;

    public var tree : Tree;

    public var itemList : ItemList;

    public var rootDirIndex : DirIndex;

    public var selectedPath : String = "project://";

    public var fileHandlers : Array<FileHandler> = new Array<FileHandler>();

    public var folderTexture : ImageTexture;

    public var nextDirs : Array<String> = new Array<String>();

    public var previousDirs : Array<String> = new Array<String>();

    public var isInitialized : Bool = false;

    public function getDirIndex(path : String = "project://",  dirIndex : DirIndex = null) : DirIndex {
        if (dirIndex == null) {
            dirIndex = rootDirIndex;
        }
        if (dirIndex.path == path) {
            return dirIndex;
        }
        for (i in 0...dirIndex.directories.length) {
            var dir = dirIndex.directories[i];
            var dIndex = getDirIndex(path, dir);
            if (dIndex != null) {
                return dIndex;
            }
        }
        return null;
    }

    public function new(ew : EditorWidget) {
        editorWidget = ew;
        ioInterface = editorWidget.ioInterface;
    }

    public function init() {
        
        //newButton = cast editorWidget.document.getObject("Control/VBoxContainer/HSplitContainer/VSplitConatiner/Dock/Explorer/VBoxContainer/Toolbar/HBoxContainer/New");
        //tree = cast editorWidget.document.getObject("Control/VBoxContainer/HSplitContainer/VSplitConatiner/Dock/Explorer/VBoxContainer/HSplitContainer/DirTree");

        try {
            folderTexture = loadIcon("app://FugueIcons/bonus/icons-32/folder.png");
        }
        catch (e) {
            Sys.println(e + " line : 82");}
        try {
            backButton = cast editorWidget.document.getObject("Control/VBoxContainer/HSplitContainer/VSplitContainer/Dock/Explorer/VBoxContainer/Toolbar/HBoxContainer/Back");
            if (backButton == null) {
                Sys.println("backButton is null");
            }
        }
        catch (e) {
            Sys.println(e + " line : 87-90");}
        try {
            LuaEvent.add(backButton.pressed, () -> goBackADir());
        }
        catch (e) {
            Sys.println(e + " line : 95");}
        try {
            forwardButton = cast editorWidget.document.getObject("Control/VBoxContainer/HSplitContainer/VSplitContainer/Dock/Explorer/VBoxContainer/Toolbar/HBoxContainer/Forward");
        }
        catch (e) {
            Sys.println(e + " line : 100");}
        try {
            if (forwardButton == null) {
                Sys.println("forwardButton is null");
            }
        }
        catch (e) {
            Sys.println(e + " line : 105-107");}
        try {
            LuaEvent.add(forwardButton.pressed, () -> goForwardADir());
        }
        catch (e) {
            Sys.println(e + " line : 112");}
        try {
            upButton = cast editorWidget.document.getObject("Control/VBoxContainer/HSplitContainer/VSplitContainer/Dock/Explorer/VBoxContainer/Toolbar/HBoxContainer/Up");
        }
        catch (e) {
            Sys.println(e + " line : 118");}
        try {
            LuaEvent.add(upButton.pressed, () -> goUpADir());
        }
        catch (e) {
            Sys.println(e + " line : 123");}
        try {
            refreshButton = cast editorWidget.document.getObject("Control/VBoxContainer/HSplitContainer/VSplitContainer/Dock/Explorer/VBoxContainer/Toolbar/HBoxContainer/Refresh");
        }
        catch (e) {
            Sys.println(e + " line : 128");}
        try {
            LuaEvent.add(refreshButton.pressed, () -> refresh());
        }
        catch (e) {
            Sys.println(e + " line : 133");}
        try {
            newButton = cast editorWidget.document.getObject("Control/VBoxContainer/HSplitContainer/VSplitContainer/Dock/Explorer/VBoxContainer/Toolbar/HBoxContainer/New");
        }
        catch (e) {
            Sys.println(e + " line : 138");}
        try {
            tree = cast editorWidget.document.getObject("Control/VBoxContainer/HSplitContainer/VSplitContainer/Dock/Explorer/VBoxContainer/HSplitContainer/DirTree");
        }
        catch (e) {
            Sys.println(e + " line : 143");}
        try {
            LuaEvent.add(tree.itemSelected, () -> onTreeItemSelected());
        }
        catch (e) {
            Sys.println(e + " line : 148");}
        try {
            //editorWidget.document.printTreePretty();
            itemList = cast editorWidget.document.getObject("Control/VBoxContainer/HSplitContainer/VSplitContainer/Dock/Explorer/VBoxContainer/HSplitContainer/CurrentDirItemList");
            untyped __lua__('_G.print(typeofobj(self.itemList))');
            //itemList = untyped __lua__('fixme(self.itemList)');
            
            if (itemList == null) {
                Sys.println("fuck");
            }
            untyped __lua__('_G.print(self.itemList.toString())');
        }
        catch (e) {
            Sys.println(e + " line : 152-159");}
        try {
            var selectIndex = 0;
            var func = (index) -> onItemListItemActivated(index);
            //untyped __lua__('_G.print(self.itemList == nil)');
            //untyped __lua__('_G.print(self.itemList.itemActivated == nil)');
            //untyped __lua__('_G.print(self.itemList.itemSelected == nil)');
            //untyped __lua__('_G.print(self.itemList.focusMode == nil)');
            //untyped __lua__('self.itemList.itemActivated.add(func)'); //addSignal
            untyped __lua__('SetOnItemActivated(self.itemList, func)');
            //LuaEvent.add(itemList.itemSelected, func);
        }
        catch (e) {
            Sys.println(e + " line : 158");}

        // Why the fuck is this in the Explorer widget
        if (OS.getName() == "macOS") {
            var menuBarControl : Control = cast editorWidget.document.getObject("Control/VBoxContainer/MenuBarControl");
            if (menuBarControl != null) {
                menuBarControl.customMinimumSize = new Vector2(0, 1);
            }
        }
    }

    public function buildRoot() : DirIndex {
        var root = new DirIndex("project://");
        root.dirName = editorWidget.projectName;

        if (root == null) {
            var acceptDialog = new AcceptDialog();
            acceptDialog.title = "Error";
            acceptDialog.dialogText = "Invalid directory index: root is null or undefined.";
            editorWidget.document.addChild(acceptDialog);
            acceptDialog.popupCentered(cast new Vector2i(0, 0));
            return null;
        }
        buildTree(root);

        return root;
    }

    public function start() : Void {
        isInitialized = false;
        rootDirIndex = buildRoot();
        createTreeItemFromDirTree(rootDirIndex);

        updatePath("project://");

        isInitialized = true;
    }

    public function refresh() : Void {
        isInitialized = false;
        rootDirIndex = buildRoot();
        createTreeItemFromDirTree(rootDirIndex);

        updatePath(selectedPath);

        isInitialized = true;
    }

    public function updatePath(path : String) {
        selectedPath = path;

        var currentDirIndex = getDirIndex(selectedPath);

        if (currentDirIndex != null) {
            itemList.clear();
            createCurrentDirItemList(currentDirIndex);
        }
    }

    public function buildTree(parent : DirIndex = null, path : String = "project://") {
        if (parent == null) {
            var acceptDialog = new AcceptDialog();
            acceptDialog.title = "Error";
            acceptDialog.dialogText = "Invalid directory index: parent is null or undefined.";
            editorWidget.document.addChild(acceptDialog);
            acceptDialog.popupCentered(cast new Vector2i(0, 0));
            return;
        }

        var directoriesTable : Table<Int, String> = cast ioInterface.getFileList(path, "/", false);
        //untyped __lua__("print(directoriesTable)");
        var directories = Table.toArray(directoriesTable);
        //trace("directories != null: " + (directories != null));

        if (directories != null) {
            var len = directories.length;
            //trace("len != null: " + (len != null));
            //trace("len: " + len);
            var start = 0;
            //trace("start != null: " + (start != null));
            for (i in start...len) {
                //trace("i: " + i);
                var dirPath = directories[i];
                //trace("dirPath: " + dirPath);
                var dirIndex = new DirIndex(dirPath, parent);
                //Sys.println("dirPath: " + dirPath);
                var dirWithoutUrl = dirPath.substring(9);
                //trace("dirWithoutUrl: " + dirWithoutUrl);
                var dirPathList = dirWithoutUrl.split("/");
                //trace("dirPathList: " + dirPathList);
                var dirName = dirPathList[dirPathList.length - 2];
                //trace("dirName: " + dirName);

                dirIndex.dirName = dirName;
                if (parent.directories == null) {
                    parent.directories = [];
                }

                parent.directories.push(dirIndex);
                buildTree(dirIndex, dirPath);
            }
        }

        var filesTable : Table<Int, String> = cast ioInterface.getFileList(path, "", false);
        var files = Table.toArray(filesTable);
        if (files != null) {
            var len = files.length;
            //trace("len != null: " + (len != null));
            //trace("len: " + len);
            var start = 0;
            //trace("start != null: " + (start != null));
            for (i in start...len) {
                //trace("i: " + i);
                var filePath = files[i];
                if (filePath.substring(filePath.length - 1) == "/") {
                    continue;
                }
                var fileIndex = new FileIndex(filePath, parent);
                var fileWithoutUrl = filePath.substring(9);
                var filePathList = fileWithoutUrl.split("/");
                var fileName = filePathList[filePathList.length - 1];
                fileIndex.fileName = fileName;
                if (parent.files == null) {
                    parent.files = [];
                }

                parent.files.push(fileIndex);
            }
        }
        
    }

    public function printTree(dirIndex : DirIndex, indent : Int = 0) {
        var indentStr = "";
        for (i in 0...indent) {
            indentStr += "  ";
        }

        Sys.println(indentStr + dirIndex.dirName);
        if (dirIndex.directories != null) {
            for (dir in dirIndex.directories) {
                printTree(dir, indent + 1);
            }
        }
        if (dirIndex.files != null) {
            for (file in dirIndex.files) {
                Sys.println(indentStr + "  " + file.fileName);
            }
        }
        
    }

    public function createTreeItemFromDirTree(dirIndex : DirIndex, parentItem : TreeItem = null) : Void {
        var treeItem : TreeItem;

        if (dirIndex == null){
            return;
        }

        var projectIconFile = ioInterface.loadBytes("app://FugueIcons/icons/application-blue-sunaba.png");
        var projectImage = new Image();
        projectImage.loadPngFromBuffer(projectIconFile);
        var projectTexture = ImageTexture.createFromImage(projectImage);

        var folderIconFile = ioInterface.loadBytes("app://FugueIcons/icons/folder.png");
        var folderImage = new Image();
        folderImage.loadPngFromBuffer(folderIconFile);
        var folderTexture = ImageTexture.createFromImage(folderImage);

        if (parentItem == null) {
            tree.clear();
            treeItem = tree.createItem(null);
            treeItem.setText(0, dirIndex.dirName);
            treeItem.setIcon(0, projectTexture);
        }
        else {
            treeItem = tree.createItem(parentItem);
            treeItem.setText(0, dirIndex.dirName);
            treeItem.setIcon(0, folderTexture);
        }

        treeItem.setMetadata(0, ToVariant.convert(dirIndex.path));
        
        if (dirIndex.directories != null) {
            for (dir in dirIndex.directories) {
                createTreeItemFromDirTree(dir, treeItem);
            }
        }
        
    }

    public function loadIcon(path : String) : ImageTexture {
        var iconFile = ioInterface.loadBytes(path);
        var iconImage = new Image();
        if (StringTools.endsWith(path, ".png")) {
            iconImage.loadPngFromBuffer(iconFile);
        }
        else if (StringTools.endsWith(path, ".jpg") || StringTools.endsWith(path, ".jpeg")) {
            iconImage.loadJpgFromBuffer (iconFile);
        }
        else if (StringTools.endsWith(path, ".bmp")) {
            iconImage.loadBmpFromBuffer(iconFile);
        }
        else if (StringTools.endsWith(path, ".webp")) {
            iconImage.loadWebpFromBuffer(iconFile);
        }
        var iconTexture = ImageTexture.createFromImage(iconImage);
        return iconTexture;
    }

    public var itemListItemCount : Int = 0;

    public function createCurrentDirItemList(dirIndex : DirIndex) {
        if (dirIndex == null) {
            return;
        }

        if (dirIndex.directories != null) {
            for (dir in dirIndex.directories) {
                itemList.addItem(
                    dir.dirName,
                    folderTexture,
                );
                itemListItemCount++;
                for (i in 0...itemListItemCount) {
                    if (itemList.getItemText(i) == dir.dirName) {
                        itemList.setItemMetadata(i, ToVariant.convert(dir.path));
                        break;
                    }
                }
            }
        }

        if (dirIndex.files != null) {
            for (file in dirIndex.files) {
                itemList.addItem(
                    file.fileName,
                    loadIcon("app://FugueIcons/bonus/icons-32/document.png"),
                );
                itemListItemCount++;
                for (i in 0...itemListItemCount) {
                    if (itemList.getItemText(i) == file.fileName) {
                        itemList.setItemMetadata(i, ToVariant.convert(file.path));
                        for (handler in fileHandlers) {
                            if (StringTools.endsWith(file.path, handler.extension)) {
                                itemList.setItemIcon(i, loadIcon(handler.iconPath));
                            }
                        }
                        break;
                    }
                }
            }
        }
        
    }

    public function onItemListItemActivated(index : Int) {
        //trace(index);
        if (!isInitialized) {
            return;
        }
        if (index == null) {
            return;
        }
        var pathVar : Variant = itemList.getItemMetadata(index);
        var path : String = pathVar.asString();
        if (itemList.getItemIcon(index) == folderTexture) {
            trace('open dir: ' + path);
            previousDirs.push(selectedPath);
            updatePath(path);
        }
        else {
            for (handler in fileHandlers) {
                if (StringTools.endsWith(path, handler.extension)) {
                    handler.openFile(path);
                    break;
                }
            }
        }
    }

    public function goForwardADir() {
        Sys.println("goForwardADir");
        if (!isInitialized) {
            return;
        }
        if (nextDirs.length > 0) {
            Sys.println(selectedPath);
            previousDirs.push(selectedPath);
            updatePath(nextDirs.pop());
            Sys.println(selectedPath);
        }
    }

    public function goBackADir() {
        Sys.println("goBackADir");
        if (!isInitialized) {
            return;
        }
        if (previousDirs.length > 0) {
            Sys.println(selectedPath);
            nextDirs.push(selectedPath);
            updatePath(previousDirs.pop());
            Sys.println(selectedPath);
        }
    }

    public function goUpADir() {
        Sys.println(selectedPath);
        if (!isInitialized) {
            return;
        }
        if (selectedPath == "project://") {
            return;
        }
        if (nextDirs.length != 0) {
            nextDirs = new Array<String>();
        }
        var pathArray = selectedPath.split("/");
        var newPath = pathArray.slice(0, pathArray.length - 1).join("/") + "/";
        if (StringTools.endsWith(selectedPath, "/")) {
            newPath = pathArray.slice(0, pathArray.length - 2).join("/") + "/";
        }
        if (!StringTools.startsWith(newPath, "project://")) {
            newPath = StringTools.replace(newPath, "project:/", "project://");
        }

        updatePath(newPath);
        Sys.println(selectedPath);
    }


    public function onTreeItemSelected() {
        if (!isInitialized) {
            return;
        }
        var selcted = tree.getSelected();
        if (selcted != null) {
            previousDirs.push(selectedPath);
            updatePath(cast selcted.getMetadata(0).asString());
        }
    }

    /*
    public function buildRoot() : DirIndex {
        var root = new DirIndex("project://");
        root.dirName = "Project";

        if (root == null) {
            var acceptDialog = new AcceptDialog();
            acceptDialog.title = "Error";
            acceptDialog.dialogText = "Invalid directory index: root is null or undefined.";
            editorWidget.document.addChild(acceptDialog);
            acceptDialog.popupCentered(new GdVector2i(0, 0));
            return null;
        }
        buildTree(root);

        return root;
    }

    public function start() {
        rootDirIndex = buildRoot();

        //printTree(rootDirIndex);
        createTreeItemFromDirTree(rootDirIndex);
    }

    public function buildTree(parent : DirIndex = null, path : String = "project://") {
        if (parent == null) {
            var acceptDialog = new AcceptDialog();
            acceptDialog.title = "Error";
            acceptDialog.dialogText = "Invalid directory index: parent is null or undefined.";
            editorWidget.document.addChild(acceptDialog);
            acceptDialog.popupCentered(new GdVector2i(0, 0));
            return;
        }

        var directoriesTable : Table<Int, String> = cast ioInterface.getFileList(path, "/", false);
        //untyped __lua__("print(directoriesTable)");
        var directories = Table.toArray(directoriesTable);
        //trace("directories != null: " + (directories != null));

        if (directories != null) {
            var len = directories.length;
            //trace("len != null: " + (len != null));
            //trace("len: " + len);
            var start = 0;
            //trace("start != null: " + (start != null));
            for (i in start...len) {
                //trace("i: " + i);
                var dirPath = directories[i];
                //trace("dirPath: " + dirPath);
                var dirIndex = new DirIndex(dirPath, parent);
                //Sys.println("dirPath: " + dirPath);
                var dirWithoutUrl = dirPath.substring(9);
                //trace("dirWithoutUrl: " + dirWithoutUrl);
                var dirPathList = dirWithoutUrl.split("/");
                //trace("dirPathList: " + dirPathList);
                var dirName = dirPathList[dirPathList.length - 2];
                //trace("dirName: " + dirName);

                dirIndex.dirName = dirName;
                if (parent.directories == null) {
                    parent.directories = [];
                }

                parent.directories.push(dirIndex);
                buildTree(dirIndex, dirPath);
            }
        }

        var filesTable : Table<Int, String> = cast ioInterface.getFileList(path, "", false);
        var files = Table.toArray(filesTable);
        if (files != null) {
            var len = files.length;
            //trace("len != null: " + (len != null));
            //trace("len: " + len);
            var start = 0;
            //trace("start != null: " + (start != null));
            for (i in start...len) {
                //trace("i: " + i);
                var filePath = files[i];
                if (filePath.substring(filePath.length - 1) == "/") {
                    continue;
                }
                var fileIndex = new FileIndex(filePath, parent);
                var fileWithoutUrl = filePath.substring(9);
                var filePathList = fileWithoutUrl.split("/");
                var fileName = filePathList[filePathList.length - 1];
                fileIndex.fileName = fileName;
                if (parent.files == null) {
                    parent.files = [];
                }

                parent.files.push(fileIndex);
            }
        }
    }

    public function printTree(dirIndex : DirIndex, indent : Int = 0) {
        var indentStr = "";
        for (i in 0...indent) {
            indentStr += "  ";
        }

        Sys.println(indentStr + dirIndex.dirName);
        if (dirIndex.directories != null) {
            for (dir in dirIndex.directories) {
                printTree(dir, indent + 1);
            }
        }
        if (dirIndex.files != null) {
            for (file in dirIndex.files) {
                Sys.println(indentStr + "  " + file.fileName);
            }
        }
        
    }

    public function createTreeItemFromDirTree(dirIndex : DirIndex, parentItem : TreeItem = null) : Void {
        //trace("dirIndex -> Name: " + dirIndex.dirName + " Path: " + dirIndex.path);
        var treeItem : TreeItem;

        if (dirIndex == null){
            trace("Invalid directory index: dirIndex is null or undefined.");
            return;
        }

        var projectIconFile = ioInterface.loadBytes("app://FugueIcons/icons/application-blue-sunaba.png");
        var projectImage = new Image();
        projectImage.loadPngFromBuffer(projectIconFile);
        var projectTexture = ImageTexture.createFromImage(projectImage);

        var folderIconFile = ioInterface.loadBytes("app://FugueIcons/icons/folder.png");
        var folderImage = new Image();
        folderImage.loadPngFromBuffer(folderIconFile);
        var folderTexture = ImageTexture.createFromImage(folderImage);

        if (parentItem == null) {
            treeItem = tree.createItem(null);
            treeItem.setText(0, dirIndex.dirName);
            treeItem.setIcon(0, projectTexture);
        }
        else {
            treeItem = tree.createItem(parentItem);
            treeItem.setText(0, dirIndex.dirName);
            treeItem.setIcon(0, folderTexture);
        }

        treeItem.setMetadata(0, ToVariant.convert(dirIndex.path));
        
        //trace("dirIndex.directories != null: " + (dirIndex.directories != null));
        if (dirIndex.directories != null) {
            for (dir in dirIndex.directories) {
                //trace("dir -> Name: " + dir.dirName + " Path: " + dir.path);
                createTreeItemFromDirTree(dir, treeItem);
            }
        }
        //trace("dirIndex.files != null: " + (dirIndex.files != null));
        /*
        if (dirIndex.files != null) {
            for (file in dirIndex.files) {
                //trace("file -> Name: " + file.fileName + " Path: " + file.path);
                var fileIconFile = ioInterface.loadBytes("app://FugueIcons/icons/document.png");
                var fileImage = new Image();
                fileImage.loadPngFromBuffer(fileIconFile);
                var fileTexture = ImageTexture.createFromImage(fileImage);
                var fileItem = tree.createItem(treeItem);
                fileItem.setText(0, file.fileName);
                fileItem.setIcon(0, fileTexture);
                fileItem.setMetadata(0, ToVariant.convert(file.path));
            }
        }
        
        
    }
    */
}