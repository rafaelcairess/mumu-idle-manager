using System.Diagnostics;

namespace StayAwake;

public static class IdleHelper
{
    public static void SetTimeout(int minutes)
    {
        Run($"/change monitor-timeout-ac {minutes}");
        Run($"/change standby-timeout-ac {minutes}");
    }

    private static void Run(string args) =>
        Process.Start(new ProcessStartInfo("powercfg", args)
        {
            CreateNoWindow = true,
            UseShellExecute = false
        })?.WaitForExit();
}
