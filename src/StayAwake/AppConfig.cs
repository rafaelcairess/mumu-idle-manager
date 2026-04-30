namespace StayAwake;

public class AppConfig
{
    public int IdleGame    { get; set; } = 120;
    public int IdleNormal  { get; set; } = 10;
    public List<string> Apps { get; set; } = new();
}
