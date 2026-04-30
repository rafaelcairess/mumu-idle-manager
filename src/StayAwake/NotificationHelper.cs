using System.Drawing;
using System.IO;
using System.Threading;
using System.Windows.Forms;

namespace StayAwake;

public static class NotificationHelper
{
    public static void Show(string title, string message)
    {
        var thread = new Thread(() =>
        {
            using var notify = new NotifyIcon();
            var icoPath = System.IO.Path.Combine(AppContext.BaseDirectory, "stayawake.ico");
            notify.Icon = File.Exists(icoPath)
                ? new Icon(icoPath)
                : SystemIcons.Application;
            notify.Visible = true;
            notify.ShowBalloonTip(4000, title, message, ToolTipIcon.None);
            Thread.Sleep(5000);
            notify.Visible = false;
        });
        thread.SetApartmentState(ApartmentState.STA);
        thread.IsBackground = true;
        thread.Start();
    }
}
