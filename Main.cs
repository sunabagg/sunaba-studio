using Godot;
using System;
using MoonSharp.Interpreter;
using Sunaba.Core;

public partial class Main : LuaNode
{
    public Closure? AboutFunction;

    public Main() : base() {
        UserData.RegisterType<Main>();
    }
    
    public override void _Ready()
    {
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
            var screen = window.CurrentScreen;
            var scale = DisplayServer.ScreenGetScale(screen);
            window.ContentScaleFactor = scale;
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

    public override void _Notification(int what)
    {
        if (what == NotificationWMAbout)
        {
            if (AboutFunction != null) {
                AboutFunction.Call();
            }
        }
    }
}
