using Microsoft.Win32;

namespace StayAwake;

public static class IFEOHelper
{
    private const string Base = @"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options";

    public static void Register(string exeName, string debuggerPath)
    {
        using var key = Registry.LocalMachine.CreateSubKey($@"{Base}\{exeName}");
        key.SetValue("Debugger", $"\"{debuggerPath}\"");
    }

    public static void Unregister(string exeName)
    {
        Registry.LocalMachine.DeleteSubKeyTree($@"{Base}\{exeName}", throwOnMissingSubKey: false);
    }
}
