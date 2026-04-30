using System;
using System.Diagnostics;
using System.IO;

namespace StayAwake;

public static class IFEORunner
{
    public static void Run(string[] args)
    {
        string appPath = args[0];
        string appName = Path.GetFileName(appPath);
        string[] passArgs = args.Length > 1 ? args[1..] : Array.Empty<string>();

        int count = RunningCounter.Increment();

        if (count == 1)
        {
            IdleHelper.KeepAwake();
            NotificationHelper.Show("StayAwake", $"{appName} aberto — monitor sempre ligado");
        }

        try
        {
            var psi = new ProcessStartInfo(appPath) { UseShellExecute = true };
            foreach (var arg in passArgs) psi.ArgumentList.Add(arg);
            Process.Start(psi)?.WaitForExit();
        }
        finally
        {
            int remaining = RunningCounter.Decrement();
            if (remaining == 0)
            {
                IdleHelper.AllowSleep();
                NotificationHelper.Show("StayAwake", $"{appName} fechado — ociosidade restaurada");
                Thread.Sleep(5500);
            }
        }
    }
}
