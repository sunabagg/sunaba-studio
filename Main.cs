using Godot;
using System;
using Sunaba.Core;

public partial class Main : LuaNode
{
    public override void _Ready() {
        try
        {
            var path = OS.GetExecutablePath().GetBaseDir();
            if (OS.HasFeature("editor"))
            {
                path = ProjectSettings.GlobalizePath("res://");
            }
            
            var assetPath = path + "/assets";
            StartFromPath(assetPath);
            
            var window = GetWindow();
            //window.Size = new Vector2I(1152, 648);
            //window.Borderless = false;
            //window.Unresizable = false;
            //window.Transparent = false;
            //window.MoveToCenter();
            var splashscreenTexture = GetNode("Splashscreen");
            if (splashscreenTexture != null)
            {
                splashscreenTexture.QueueFree();
            }
        }
        catch (Exception e)
        {
            var dialog = new AcceptDialogPlus(AcceptDialogPlus.TypeEnum.Error);
            dialog.Text = e.ToString();
            dialog.Title = "Error";
            AddChild(dialog);
            dialog.PopupCentered();
        }
    }
}
