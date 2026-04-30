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

        var config = ConfigManager.Load();
        int count = RunningCounter.Increment();

        if (count == 1)
        {
            IdleHelper.SetTimeout(config.IdleGame);
            NotificationHelper.Show("StayAwake", $"{appName} aberto — ociosidade: {config.IdleGame} min");
        }

        try
        {
            var psi = new ProcessStartInfo(appPath) { UseShellExecute = false };
            foreach (var arg in passArgs) psi.ArgumentList.Add(arg);
            Process.Start(psi)?.WaitForExit();
        }
        finally
        {
            int remaining = RunningCounter.Decrement();
            if (remaining == 0)
            {
                IdleHelper.SetTimeout(config.IdleNormal);
                NotificationHelper.Show("StayAwake", $"{appName} fechado — ociosidade: {config.IdleNormal} min restaurado");
                Thread.Sleep(5500); // aguarda notificação aparecer antes de encerrar
            }
        }
    }
}
