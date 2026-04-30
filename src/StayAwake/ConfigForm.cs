using System;
using System.Drawing;
using System.IO;
using System.Windows.Forms;

namespace StayAwake;

public class ConfigForm : Form
{
    private readonly ListBox       _list;
    private readonly NumericUpDown _spinGame;
    private readonly NumericUpDown _spinNormal;
    private readonly AppConfig     _config;
    private readonly string        _selfPath;

    public ConfigForm()
    {
        _config   = ConfigManager.Load();
        _selfPath = Environment.ProcessPath
                    ?? Path.Combine(AppContext.BaseDirectory, "StayAwake.exe");

        // Janela
        Text            = "StayAwake";
        Size            = new Size(440, 350);
        StartPosition   = FormStartPosition.CenterScreen;
        FormBorderStyle = FormBorderStyle.FixedDialog;
        MaximizeBox     = false;

        var icoPath = Path.Combine(AppContext.BaseDirectory, "stayawake.ico");
        if (File.Exists(icoPath)) Icon = new Icon(icoPath);

        // Label apps
        var lblApps = new Label
        {
            Text     = "Apps monitorados:",
            Location = new Point(20, 15),
            Size     = new Size(200, 18)
        };

        // Lista
        _list = new ListBox { Location = new Point(20, 35), Size = new Size(385, 120) };
        foreach (var app in _config.Apps) _list.Items.Add(app);

        // Botão adicionar
        var btnAdd = new Button { Text = "+ Adicionar app", Location = new Point(20, 165), Size = new Size(120, 28) };
        btnAdd.Click += OnAdd;

        // Botão remover
        var btnRemove = new Button { Text = "Remover", Location = new Point(150, 165), Size = new Size(80, 28) };
        btnRemove.Click += (_, _) => { if (_list.SelectedItem != null) _list.Items.Remove(_list.SelectedItem); };

        // Idle durante o app
        var lblGame = new Label
        {
            Text     = "Ociosidade durante o app (min):",
            Location = new Point(20, 220),
            Size     = new Size(235, 18)
        };
        _spinGame = new NumericUpDown
        {
            Location = new Point(260, 218),
            Size     = new Size(60, 20),
            Minimum  = 1, Maximum = 480,
            Value    = _config.IdleGame
        };

        // Idle ao fechar
        var lblNormal = new Label
        {
            Text     = "Ociosidade ao fechar o app (min):",
            Location = new Point(20, 258),
            Size     = new Size(235, 18)
        };
        _spinNormal = new NumericUpDown
        {
            Location = new Point(260, 256),
            Size     = new Size(60, 20),
            Minimum  = 1, Maximum = 480,
            Value    = _config.IdleNormal
        };

        // Botões Salvar / Cancelar
        var btnSave = new Button { Text = "Salvar", Location = new Point(240, 295), Size = new Size(80, 28) };
        btnSave.Click += OnSave;

        var btnCancel = new Button { Text = "Cancelar", Location = new Point(330, 295), Size = new Size(80, 28) };
        btnCancel.Click += (_, _) => Close();

        Controls.AddRange(new Control[]
        {
            lblApps, _list, btnAdd, btnRemove,
            lblGame, _spinGame,
            lblNormal, _spinNormal,
            btnSave, btnCancel
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
            if (!_list.Items.Contains(name)) _list.Items.Add(name);
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

        _config.Apps       = newApps;
        _config.IdleGame   = (int)_spinGame.Value;
        _config.IdleNormal = (int)_spinNormal.Value;
        ConfigManager.Save(_config);

        MessageBox.Show(
            $"Salvo! {newApps.Count} app(s) monitorado(s).",
            "StayAwake", MessageBoxButtons.OK, MessageBoxIcon.Information);

        Close();
    }
}
