namespace StayAwake;

static class Program
{
    [STAThread]
    static void Main(string[] args)
    {
        Application.EnableVisualStyles();
        Application.SetCompatibleTextRenderingDefault(false);

        if (args.Length > 0)
            IFEORunner.Run(args);
        else
            Application.Run(new ConfigForm());
    }
}
