using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;

namespace StayAwake;

public class ProcessPickerForm : Form
{
    public string? SelectedExeName { get; private set; }

    private readonly ListBox _list;
    private readonly TextBox _search;
    private List<string> _allProcesses = new();

    public ProcessPickerForm()
    {
        Text            = "Selecionar app em execução";
        ClientSize      = new Size(380, 420);
        StartPosition   = FormStartPosition.CenterParent;
        FormBorderStyle = FormBorderStyle.FixedDialog;
        MaximizeBox     = false;

        var lblSearch = new Label
        {
            Text     = "Filtrar:",
            Location = new Point(16, 16),
            Size     = new Size(50, 20)
        };

        _search = new TextBox
        {
            Location = new Point(66, 14),
            Size     = new Size(298, 22)
        };
        _search.TextChanged += (_, _) => RefreshList();

        var lblList = new Label
        {
            Text     = "Processos em execução:",
            Location = new Point(16, 46),
            Size     = new Size(200, 18)
        };

        _list = new ListBox
        {
            Location      = new Point(16, 68),
            Size          = new Size(348, 290),
            Sorted        = true,
            IntegralHeight = false
        };
        _list.DoubleClick += OnSelect;

        var btnSelect = new Button
        {
            Text     = "Selecionar",
            Location = new Point(196, 374),
            Size     = new Size(90, 30)
        };
        btnSelect.Click += OnSelect;

        var btnCancel = new Button
        {
            Text     = "Cancelar",
            Location = new Point(296, 374),
            Size     = new Size(80, 30)
        };
        btnCancel.Click += (_, _) => { SelectedExeName = null; Close(); };

        var btnBrowse = new Button
        {
            Text     = "Procurar arquivo...",
            Location = new Point(16, 374),
            Size     = new Size(130, 30)
        };
        btnBrowse.Click += OnBrowse;

        Controls.AddRange(new Control[]
        {
            lblSearch, _search, lblList, _list, btnSelect, btnCancel, btnBrowse
        });

        LoadProcesses();
    }

    private void LoadProcesses()
    {
        _allProcesses = Process.GetProcesses()
            .Where(p =>
            {
                try { return p.MainWindowHandle != IntPtr.Zero && !string.IsNullOrEmpty(p.ProcessName); }
                catch { return false; }
            })
            .Select(p => p.ProcessName + ".exe")
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .OrderBy(p => p)
            .ToList();

        RefreshList();
    }

    private void RefreshList()
    {
        var filter = _search.Text.Trim();
        _list.Items.Clear();
        foreach (var p in _allProcesses)
            if (string.IsNullOrEmpty(filter) || p.Contains(filter, StringComparison.OrdinalIgnoreCase))
                _list.Items.Add(p);
    }

    private void OnSelect(object? sender, EventArgs e)
    {
        if (_list.SelectedItem == null) return;
        SelectedExeName = _list.SelectedItem.ToString();
        DialogResult = DialogResult.OK;
        Close();
    }

    private void OnBrowse(object? sender, EventArgs e)
    {
        using var dlg = new OpenFileDialog
        {
            Filter = "Executável (*.exe)|*.exe",
            Title  = "Selecione o aplicativo"
        };
        if (dlg.ShowDialog() == DialogResult.OK)
        {
            SelectedExeName = System.IO.Path.GetFileName(dlg.FileName);
            DialogResult = DialogResult.OK;
            Close();
        }
    }
}
