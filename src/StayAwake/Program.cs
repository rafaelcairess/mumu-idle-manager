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
            // Modo IFEO — chamado pelo Windows ao abrir um app monitorado
            IFEORunner.Run(args);
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
        var principal = new WindowsPrincipal(identity);
        return principal.IsInRole(WindowsBuiltInRole.Administrator);
    }

    private static void RestartAsAdmin()
    {
        var psi = new System.Diagnostics.ProcessStartInfo
        {
            FileName        = Environment.ProcessPath ?? "StayAwake.exe",
            UseShellExecute = true,
            Verb            = "runas"
        };
        try { System.Diagnostics.Process.Start(psi); }
        catch { /* usuário cancelou o UAC */ }
    }
}
