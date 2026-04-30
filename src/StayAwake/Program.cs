using System.Security.Principal;

namespace StayAwake;

static class Program
{
    [STAThread]
    static void Main(string[] args)
    {
        Application.EnableVisualStyles();
        Application.SetCompatibleTextRenderingDefault(false);

        if (args.Length > 0)
        {
            // Modo IFEO — roda em background com message pump ativo
            // (sem message pump o Windows mostra cursor de carregamento indefinidamente)
            var context = new ApplicationContext();
            Task.Run(() =>
            {
                IFEORunner.Run(args);
                context.ExitThread();
            });
            Application.Run(context);
        }
        else
        {
            // Modo Config — requer admin para escrever no registro
            if (!IsAdmin())
            {
                RestartAsAdmin();
                return;
            }
            Application.Run(new ConfigForm());
        }
    }

    private static bool IsAdmin()
    {
        using var identity = WindowsIdentity.GetCurrent();
        return new WindowsPrincipal(identity).IsInRole(WindowsBuiltInRole.Administrator);
    }

    private static void RestartAsAdmin()
    {
        try
        {
            System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo
            {
                FileName        = Environment.ProcessPath ?? "StayAwake.exe",
                UseShellExecute = true,
                Verb            = "runas"
            });
        }
        catch { /* usuário cancelou UAC */ }
    }
}
