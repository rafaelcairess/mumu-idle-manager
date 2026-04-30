using System.Runtime.InteropServices;

namespace StayAwake;

public static class IdleHelper
{
    [DllImport("kernel32.dll")]
    private static extern uint SetThreadExecutionState(uint esFlags);

    private const uint ES_CONTINUOUS       = 0x80000000;
    private const uint ES_SYSTEM_REQUIRED  = 0x00000001;
    private const uint ES_DISPLAY_REQUIRED = 0x00000002;

    // Impede o monitor e o sistema de dormir — sem precisar de admin
    public static void KeepAwake() =>
        SetThreadExecutionState(ES_CONTINUOUS | ES_DISPLAY_REQUIRED | ES_SYSTEM_REQUIRED);

    // Restaura o comportamento normal do Windows
    public static void AllowSleep() =>
        SetThreadExecutionState(ES_CONTINUOUS);
}
