using System.IO;
using System.Text.Json;
using System.Threading;

namespace StayAwake;

public static class RunningCounter
{
    private static readonly string File = System.IO.Path.Combine(
        System.IO.Path.GetTempPath(), "stayawake_running.json");

    private static readonly Mutex Mutex = new(false, "StayAwake_RunningMutex");

    public static int Increment() => Update(n => n + 1);
    public static int Decrement() => Update(n => Math.Max(0, n - 1));

    private static int Update(Func<int, int> fn)
    {
        Mutex.WaitOne();
        try
        {
            int count = fn(Read());
            System.IO.File.WriteAllText(File,
                JsonSerializer.Serialize(new { Count = count }));
            return count;
        }
        finally { Mutex.ReleaseMutex(); }
    }

    private static int Read()
    {
        if (!System.IO.File.Exists(File)) return 0;
        try
        {
            using var doc = JsonDocument.Parse(System.IO.File.ReadAllText(File));
            return doc.RootElement.GetProperty("Count").GetInt32();
        }
        catch { return 0; }
    }
}
