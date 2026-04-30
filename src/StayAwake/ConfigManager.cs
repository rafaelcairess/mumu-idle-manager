using System.IO;
using System.Text.Json;

namespace StayAwake;

public static class ConfigManager
{
    private static readonly string Path = System.IO.Path.Combine(
        AppContext.BaseDirectory, "config.json");

    public static AppConfig Load()
    {
        if (!File.Exists(Path)) return new AppConfig();
        try
        {
            return JsonSerializer.Deserialize<AppConfig>(File.ReadAllText(Path)) ?? new AppConfig();
        }
        catch { return new AppConfig(); }
    }

    public static void Save(AppConfig config)
    {
        File.WriteAllText(Path, JsonSerializer.Serialize(config, new JsonSerializerOptions { WriteIndented = true }));
    }
}
