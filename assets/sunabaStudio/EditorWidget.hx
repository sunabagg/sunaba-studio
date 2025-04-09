package sunabaStudio;

import sunaba.godot.Vector2i;
import sunaba.godot.Node;
import sunaba.godot.Image;
import sunaba.godot.ImageTexture;
import sunaba.godot.AcceptDialog;
import sunaba.godot.MenuBar;
import sunaba.godot.OS;
import lua.Table;
import sunaba.ToVariant;
import sunaba.godot.StringName;
import sunaba.ui.Widget;
import sunaba.godot.FileDialog;
import sunaba.core.LuaEvent;
import sunaba.godot.Button;
import sunaba.ui.Widget;
import sunaba.godot.PopupMenu;
import sunaba.godot.GdVector2i;
import sunaba.io.IoManager;
import sunaba.godot.extensions.TabManager;
import sunabaStudio.explorer.fileHandlers.HxFileHandler;
import sunaba.godot.extensions.AcceptDialogPlus;

class EditorWidget extends Widget {
    public var fileMenu: PopupMenu;
    public var editMenu: PopupMenu;
    public var helpMenu: PopupMenu;

    public var newProjectButton : Button;
    public var openProjectButton : Button;

    public var openFileDialog : FileDialog;

    public var projectPath : String;

    public var projectName : String;

    public var explorer : Explorer;

    public var contentView : TabManager;

    public var children : Array<EditorChild> = new Array<EditorChild>();

    var aboutDialog : AcceptDialogPlus;

    var rootNode : Node;

    public override function init() {
        rootNode = document.getParent();
        var plugins : Array<Plugin> = new Array<Plugin>();
        untyped __lua__("_G.plugins = self.plugins");

        var globalPluginFileListTable = ioInterface.getFileList("app://plugins", "", false);
        var globalPluginFileList = Table.toArray(globalPluginFileListTable);
        for (i in 0...globalPluginFileList.length) {
            var pluginFilePath = globalPluginFileList[i];
            untyped __lua__("require(pluginFilePath)");
        }

        explorer = new Explorer(this);
        document.load("app://sunabaStudio/EditorWidget.xml");
        explorer.init();
        explorer.fileHandlers.push(new HxFileHandler(this, explorer));

        contentView = cast document.getObject("Control/VBoxContainer/HSplitContainer/VSplitContainer/ContentView");

        fileMenu = cast document.getObject("Control/VBoxContainer/MenuBarControl/MenuBar/File");
        Sys.println(fileMenu.toString());
        editMenu = cast document.getObject("Control/VBoxContainer/MenuBarControl/MenuBar/Edit");
        helpMenu = cast document.getObject("Control/VBoxContainer/MenuBarControl/MenuBar/Help");

        if (OS.getName() == "macOS") {
            var menuBar : MenuBar = cast document.getObject("Control/VBoxContainer/MenuBarControl/MenuBar");
            var helpMeuIndex = helpMenu.getIndex();
            menuBar.setMenuHidden(helpMeuIndex, true);
        }

        aboutDialog = new AcceptDialogPlus(DialogPlusType.Info);
        aboutDialog.title = "About";
        var iconImage = new Image();
        iconImage.loadPngFromBuffer(ioInterface.loadBytes("app://about-icon.png"));
        var iconTexture = ImageTexture.createFromImage(iconImage);
        aboutDialog.setIcon(iconTexture);
        aboutDialog.text = "Sunaba Studio\n";
        aboutDialog.text += "Version: 0.7.0\n";
        aboutDialog.text += "Copyright (C) 2022-2025 mintkat\n";
        document.addChild(aboutDialog);
        aboutDialog.hide();
        //var scaleFactor = ;
        var aboutDialogSize : GdVector2i = cast aboutDialog.minSize;
            var sizeX = aboutDialogSize.x;
            sizeX = Std.int(sizeX * aboutDialog.contentScaleFactor);
            aboutDialogSize.x = sizeX;
            aboutDialog.minSize = aboutDialogSize;
        

        var helpMenuFunc = (id : Int) -> {
            if (id == 0) {
                var aboutDialogSize : GdVector2i = cast aboutDialog.minSize;
                var sizeX = aboutDialogSize.x;
                sizeX = Std.int(sizeX * aboutDialog.contentScaleFactor);
                aboutDialogSize.x = sizeX;
                aboutDialog.popupCentered(aboutDialogSize);
            }
        };
        untyped __lua__("_G.addLuaFuncToIntEvent(self.helpMenu, 'IdPressed', helpMenuFunc)");

        var aboutFuncMacOS = function() {
            var aboutDialogSize : GdVector2i = cast aboutDialog.minSize;
            var sizeX = aboutDialogSize.x;
            sizeX = Std.int(sizeX * aboutDialog.contentScaleFactor);
            aboutDialogSize.x = sizeX;
            aboutDialog.popupCentered(aboutDialogSize);
        }
        
        untyped rootNode.aboutFunction = aboutFuncMacOS;

        try {
            var func = (id : Int) -> onFileMenuPressed(id);
            //LuaEvent.add(fileMenu.idPressed, func);
            untyped __lua__("_G.print('self.fileMenu ~= nil : ' .. tostring(self.fileMenu ~= nil))");
            untyped __lua__("_G.print('func ~= nil : ' .. tostring(func ~= nil))");
            untyped __lua__("_G.addLuaFuncToIntEvent(self.fileMenu, 'IdPressed', func)");
        }
        catch (e) {
            trace(e);
        }

        newProjectButton = cast document.getObject("Control/VBoxContainer/Toolbar/Control/LeftToolbar/NewProject");
        openProjectButton = cast document.getObject("Control/VBoxContainer/Toolbar/Control/LeftToolbar/OpenProject");

        LuaEvent.add(newProjectButton.pressed, () -> onNewProject());
        LuaEvent.add(openProjectButton.pressed, () -> openProjectDialog());

        openFileDialog = new FileDialog();
        openFileDialog.access = 2;
        openFileDialog.fileMode = 2;
        if (OS.getName() == "Windows" || OS.getName() == "macOS") {
            openFileDialog.useNativeDialog = true;
        }
        //openFileDialog.addFilter("*.sunaba", "Sunaba Project");
        openFileDialog.title = "Open Project";

        LuaEvent.add(openFileDialog.dirSelected, (dirPath : String) -> openProject(dirPath));

        document.addChild(openFileDialog);

        for (i in 0...plugins.length) {
            var plugin = plugins[i];
            plugin.explorer = explorer;
            plugin.editorWidget = this;
            plugin.init();
        }
    }

    public function onNewProject() {
        //trace("New Project");
        //trace(untyped __lua__("self ~= nil"));
    }

    public function openProject(dirPath : String) {   
        //var filePathArray = filePath.split("/");
        //var fileName = filePathArray[filePathArray.length - 1];
        //projectName = fileName;
        //filePathArray.remove(fileName);
        //var dirPath = filePathArray.join("/");
        projectPath = dirPath;

        //trace("Open Project: " + dirPath);
        projectPath = dirPath;

        var ioManager : IoManager = cast ioInterface;
        ioManager.registerPath(dirPath, "project://");

        if (ioInterface.directoryExists("project://plugins/")) {
            var projectPluginFileListTable = ioInterface.getFileList("project://plugins", "", false);
            var projectPluginFileList = Table.toArray(projectPluginFileListTable);
            for (i in 0...projectPluginFileList.length) {
                var pluginFilePath = projectPluginFileList[i];
                untyped __lua__("require(pluginFilePath)");
            }

            var plugins : Array<Plugin> = new Array<Plugin>();
            untyped __lua__("_G.plugins = self.plugins");
            for (i in 0...plugins.length) {
                var plugin = plugins[i];
                plugin.explorer = explorer;
                plugin.editorWidget = this;
                plugin.init();
            }
        }

        try {
            explorer.start();
        } catch (e : Dynamic) {
            trace("Error: " + e);
        }
    }

    public function openProjectDialog() {
        trace("Open Project");
        var fileDialogSize = new GdVector2i(550, 350);
        openFileDialog.popupCentered(fileDialogSize);
        //fileDialog.currentDir = "res://";
    }

    public function onFileMenuPressed(id : Int) {
        if (id == 0) {
            
        }
        else if (id == 1) {
            openProjectDialog();
        }
    }
}