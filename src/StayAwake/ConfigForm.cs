using System;
using System.Drawing;
using System.IO;
using System.Windows.Forms;

namespace StayAwake;

public class ConfigForm : Form
{
    private readonly ListBox   _list;
    private readonly AppConfig _config;
    private readonly string    _selfPath;

    public ConfigForm()
    {
        _config   = ConfigManager.Load();
        _selfPath = Environment.ProcessPath
                    ?? Path.Combine(AppContext.BaseDirectory, "StayAwake.exe");

        var icoPath = Path.Combine(AppContext.BaseDirectory, "stayawake.ico");

        Text            = "StayAwake";
        ClientSize      = new Size(420, 260);
        StartPosition   = FormStartPosition.CenterScreen;
        FormBorderStyle = FormBorderStyle.FixedDialog;
        MaximizeBox     = false;
        if (File.Exists(icoPath)) Icon = new Icon(icoPath);

        // Label
        var lblApps = new Label
        {
            Text     = "Apps monitorados:",
            Location = new Point(20, 16),
            Size     = new Size(200, 18)
        };

        // Lista
        _list = new ListBox
        {
            Location = new Point(20, 38),
            Size     = new Size(380, 140)
        };
        foreach (var app in _config.Apps) _list.Items.Add(app);

        // Botão adicionar
        var btnAdd = new Button
        {
            Text     = "+ Adicionar app",
            Location = new Point(20, 188),
            Size     = new Size(120, 28)
        };
        btnAdd.Click += OnAdd;

        // Botão remover
        var btnRemove = new Button
        {
            Text     = "Remover",
            Location = new Point(150, 188),
            Size     = new Size(80, 28)
        };
        btnRemove.Click += (_, _) =>
        {
            if (_list.SelectedItem != null)
                _list.Items.Remove(_list.SelectedItem);
        };

        // Salvar
        var btnSave = new Button
        {
            Text     = "Salvar",
            Location = new Point(230, 220),
            Size     = new Size(80, 28)
        };
        btnSave.Click += OnSave;

        // Cancelar
        var btnCancel = new Button
        {
            Text     = "Cancelar",
            Location = new Point(320, 220),
            Size     = new Size(80, 28)
        };
        btnCancel.Click += (_, _) => Close();

        Controls.AddRange(new Control[]
        {
            lblApps, _list, btnAdd, btnRemove, btnSave, btnCancel
        });
    }

    private void OnAdd(object? sender, EventArgs e)
    {
        using var dlg = new OpenFileDialog
        {
            Filter = "Executável (*.exe)|*.exe",
            Title  = "Selecione o aplicativo"
        };
        if (dlg.ShowDialog() == DialogResult.OK)
        {
            var name = Path.GetFileName(dlg.FileName);
            if (!_list.Items.Contains(name))
                _list.Items.Add(name);
        }
    }

    private void OnSave(object? sender, EventArgs e)
    {
        var newApps = new List<string>();
        foreach (var item in _list.Items) newApps.Add(item.ToString()!);

        foreach (var app in newApps)
            if (!_config.Apps.Contains(app))
                IFEOHelper.Register(app, _selfPath);

        foreach (var app in _config.Apps)
            if (!newApps.Contains(app))
                IFEOHelper.Unregister(app);

        _config.Apps = newApps;
        ConfigManager.Save(_config);

        MessageBox.Show(
            $"Salvo! {newApps.Count} app(s) monitorado(s).",
            "StayAwake", MessageBoxButtons.OK, MessageBoxIcon.Information);

        Close();
    }
}
