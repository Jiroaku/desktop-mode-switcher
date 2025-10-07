# Desktop Switcher GUI
# A simple GUI for managing desktop modes

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === GLOBAL VARIABLES ===
$configPath = ".\config.json"
$config = $null

# === FUNCTIONS ===
function Load-Config {
    if (Test-Path $configPath) {
        try {
            $script:config = Get-Content $configPath | ConvertFrom-Json
            return $true
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error loading config: $($_.Exception.Message)", "Error", "OK", "Error")
            return $false
        }
    }
    return $false
}

function Save-Config {
    try {
        $config | ConvertTo-Json -Depth 10 | Set-Content -Path $configPath -Encoding UTF8
        return $true
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Error saving config: $($_.Exception.Message)", "Error", "OK", "Error")
        return $false
    }
}

function Switch-ToGamingMode {
    try {
        schtasks /Run /TN "DesktopSwitcher-GamingMode"
        [System.Windows.Forms.MessageBox]::Show("Gaming Mode activated!", "Success", "OK", "Information")
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Error switching to Gaming Mode: $($_.Exception.Message)", "Error", "OK", "Error")
    }
}

function Switch-ToProductivityMode {
    try {
        schtasks /Run /TN "DesktopSwitcher-NormalMode"
        [System.Windows.Forms.MessageBox]::Show("Productivity Mode activated!", "Success", "OK", "Information")
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Error switching to Productivity Mode: $($_.Exception.Message)", "Error", "OK", "Error")
    }
}

function Show-ConfigForm {
    $configForm = New-Object System.Windows.Forms.Form
    $configForm.Text = "Desktop Switcher Configuration"
    $configForm.Size = New-Object System.Drawing.Size(600, 500)
    $configForm.StartPosition = "CenterScreen"
    $configForm.FormBorderStyle = "FixedDialog"
    $configForm.MaximizeBox = $false

    # NirCmd Path
    $lblNirCmd = New-Object System.Windows.Forms.Label
    $lblNirCmd.Text = "NirCmd Path:"
    $lblNirCmd.Location = New-Object System.Drawing.Point(20, 20)
    $lblNirCmd.Size = New-Object System.Drawing.Size(100, 20)
    $configForm.Controls.Add($lblNirCmd)

    $txtNirCmd = New-Object System.Windows.Forms.TextBox
    $txtNirCmd.Text = $config.nircmd_path
    $txtNirCmd.Location = New-Object System.Drawing.Point(130, 18)
    $txtNirCmd.Size = New-Object System.Drawing.Size(350, 20)
    $configForm.Controls.Add($txtNirCmd)

    $btnBrowseNirCmd = New-Object System.Windows.Forms.Button
    $btnBrowseNirCmd.Text = "Browse"
    $btnBrowseNirCmd.Location = New-Object System.Drawing.Point(490, 16)
    $btnBrowseNirCmd.Size = New-Object System.Drawing.Size(80, 25)
    $btnBrowseNirCmd.Add_Click({
        $openFile = New-Object System.Windows.Forms.OpenFileDialog
        $openFile.Filter = "Executable files (*.exe)|*.exe"
        $openFile.Title = "Select NirCmd executable"
        if ($openFile.ShowDialog() -eq "OK") {
            $txtNirCmd.Text = $openFile.FileName
        }
    })
    $configForm.Controls.Add($btnBrowseNirCmd)

    # Gaming Resolution
    $lblGamingRes = New-Object System.Windows.Forms.Label
    $lblGamingRes.Text = "Gaming Resolution:"
    $lblGamingRes.Location = New-Object System.Drawing.Point(20, 60)
    $lblGamingRes.Size = New-Object System.Drawing.Size(120, 20)
    $configForm.Controls.Add($lblGamingRes)

    $txtGamingWidth = New-Object System.Windows.Forms.TextBox
    $txtGamingWidth.Text = $config.gaming_mode.resolution.width
    $txtGamingWidth.Location = New-Object System.Drawing.Point(150, 58)
    $txtGamingWidth.Size = New-Object System.Drawing.Size(60, 20)
    $configForm.Controls.Add($txtGamingWidth)

    $lblX = New-Object System.Windows.Forms.Label
    $lblX.Text = "x"
    $lblX.Location = New-Object System.Drawing.Point(220, 60)
    $lblX.Size = New-Object System.Drawing.Size(10, 20)
    $configForm.Controls.Add($lblX)

    $txtGamingHeight = New-Object System.Windows.Forms.TextBox
    $txtGamingHeight.Text = $config.gaming_mode.resolution.height
    $txtGamingHeight.Location = New-Object System.Drawing.Point(240, 58)
    $txtGamingHeight.Size = New-Object System.Drawing.Size(60, 20)
    $configForm.Controls.Add($txtGamingHeight)

    $lblGamingRefresh = New-Object System.Windows.Forms.Label
    $lblGamingRefresh.Text = "@"
    $lblGamingRefresh.Location = New-Object System.Drawing.Point(310, 60)
    $lblGamingRefresh.Size = New-Object System.Drawing.Size(10, 20)
    $configForm.Controls.Add($lblGamingRefresh)

    $txtGamingRefresh = New-Object System.Windows.Forms.TextBox
    $txtGamingRefresh.Text = $config.gaming_mode.resolution.refresh_rate
    $txtGamingRefresh.Location = New-Object System.Drawing.Point(330, 58)
    $txtGamingRefresh.Size = New-Object System.Drawing.Size(50, 20)
    $configForm.Controls.Add($txtGamingRefresh)

    $lblHz = New-Object System.Windows.Forms.Label
    $lblHz.Text = "Hz"
    $lblHz.Location = New-Object System.Drawing.Point(390, 60)
    $lblHz.Size = New-Object System.Drawing.Size(20, 20)
    $configForm.Controls.Add($lblHz)

    # Productivity Resolution
    $lblProdRes = New-Object System.Windows.Forms.Label
    $lblProdRes.Text = "Productivity Resolution:"
    $lblProdRes.Location = New-Object System.Drawing.Point(20, 90)
    $lblProdRes.Size = New-Object System.Drawing.Size(120, 20)
    $configForm.Controls.Add($lblProdRes)

    $txtProdWidth = New-Object System.Windows.Forms.TextBox
    $txtProdWidth.Text = $config.productivity_mode.resolution.width
    $txtProdWidth.Location = New-Object System.Drawing.Point(150, 88)
    $txtProdWidth.Size = New-Object System.Drawing.Size(60, 20)
    $configForm.Controls.Add($txtProdWidth)

    $lblX2 = New-Object System.Windows.Forms.Label
    $lblX2.Text = "x"
    $lblX2.Location = New-Object System.Drawing.Point(220, 90)
    $lblX2.Size = New-Object System.Drawing.Size(10, 20)
    $configForm.Controls.Add($lblX2)

    $txtProdHeight = New-Object System.Windows.Forms.TextBox
    $txtProdHeight.Text = $config.productivity_mode.resolution.height
    $txtProdHeight.Location = New-Object System.Drawing.Point(240, 88)
    $txtProdHeight.Size = New-Object System.Drawing.Size(60, 20)
    $configForm.Controls.Add($txtProdHeight)

    $lblProdRefresh = New-Object System.Windows.Forms.Label
    $lblProdRefresh.Text = "@"
    $lblProdRefresh.Location = New-Object System.Drawing.Point(310, 90)
    $lblProdRefresh.Size = New-Object System.Drawing.Size(10, 20)
    $configForm.Controls.Add($lblProdRefresh)

    $txtProdRefresh = New-Object System.Windows.Forms.TextBox
    $txtProdRefresh.Text = $config.productivity_mode.resolution.refresh_rate
    $txtProdRefresh.Location = New-Object System.Drawing.Point(330, 88)
    $txtProdRefresh.Size = New-Object System.Drawing.Size(50, 20)
    $configForm.Controls.Add($txtProdRefresh)

    $lblHz2 = New-Object System.Windows.Forms.Label
    $lblHz2.Text = "Hz"
    $lblHz2.Location = New-Object System.Drawing.Point(390, 90)
    $lblHz2.Size = New-Object System.Drawing.Size(20, 20)
    $configForm.Controls.Add($lblHz2)

    # Apps to Kill
    $lblAppsToKill = New-Object System.Windows.Forms.Label
    $lblAppsToKill.Text = "Apps to close in Gaming Mode (one per line):"
    $lblAppsToKill.Location = New-Object System.Drawing.Point(20, 130)
    $lblAppsToKill.Size = New-Object System.Drawing.Size(300, 20)
    $configForm.Controls.Add($lblAppsToKill)

    $txtAppsToKill = New-Object System.Windows.Forms.TextBox
    $txtAppsToKill.Multiline = $true
    $txtAppsToKill.ScrollBars = "Vertical"
    $txtAppsToKill.Text = ($config.gaming_mode.processes_to_kill -join "`n")
    $txtAppsToKill.Location = New-Object System.Drawing.Point(20, 155)
    $txtAppsToKill.Size = New-Object System.Drawing.Size(550, 100)
    $configForm.Controls.Add($txtAppsToKill)

    # Buttons
    $btnSave = New-Object System.Windows.Forms.Button
    $btnSave.Text = "Save Configuration"
    $btnSave.Location = New-Object System.Drawing.Point(400, 270)
    $btnSave.Size = New-Object System.Drawing.Size(120, 30)
    $btnSave.Add_Click({
        $config.nircmd_path = $txtNirCmd.Text
        $config.gaming_mode.resolution.width = [int]$txtGamingWidth.Text
        $config.gaming_mode.resolution.height = [int]$txtGamingHeight.Text
        $config.gaming_mode.resolution.refresh_rate = [int]$txtGamingRefresh.Text
        $config.productivity_mode.resolution.width = [int]$txtProdWidth.Text
        $config.productivity_mode.resolution.height = [int]$txtProdHeight.Text
        $config.productivity_mode.resolution.refresh_rate = [int]$txtProdRefresh.Text
        $config.gaming_mode.processes_to_kill = $txtAppsToKill.Text -split "`n" | Where-Object { $_.Trim() -ne "" }

        if (Save-Config) {
            [System.Windows.Forms.MessageBox]::Show("Configuration saved successfully!", "Success", "OK", "Information")
            $configForm.Close()
        }
    })
    $configForm.Controls.Add($btnSave)

    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Text = "Cancel"
    $btnCancel.Location = New-Object System.Drawing.Point(530, 270)
    $btnCancel.Size = New-Object System.Drawing.Size(60, 30)
    $btnCancel.Add_Click({ $configForm.Close() })
    $configForm.Controls.Add($btnCancel)

    $configForm.ShowDialog()
}

# === MAIN FORM ===
if (-not (Load-Config)) {
    [System.Windows.Forms.MessageBox]::Show("Configuration file not found. Please run the setup script first.", "Error", "OK", "Error")
    exit 1
}

$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = "Desktop Switcher"
$mainForm.Size = New-Object System.Drawing.Size(400, 300)
$mainForm.StartPosition = "CenterScreen"
$mainForm.FormBorderStyle = "FixedDialog"
$mainForm.MaximizeBox = $false

# Title
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "🖥️ Desktop Switcher"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$lblTitle.Location = New-Object System.Drawing.Point(20, 20)
$lblTitle.Size = New-Object System.Drawing.Size(350, 30)
$mainForm.Controls.Add($lblTitle)

# Gaming Mode Button
$btnGaming = New-Object System.Windows.Forms.Button
$btnGaming.Text = "🎮 Switch to Gaming Mode"
$btnGaming.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$btnGaming.BackColor = [System.Drawing.Color]::FromArgb(46, 125, 50)
$btnGaming.ForeColor = [System.Drawing.Color]::White
$btnGaming.FlatStyle = "Flat"
$btnGaming.Location = New-Object System.Drawing.Point(50, 70)
$btnGaming.Size = New-Object System.Drawing.Size(300, 50)
$btnGaming.Add_Click({ Switch-ToGamingMode })
$mainForm.Controls.Add($btnGaming)

# Productivity Mode Button
$btnProductivity = New-Object System.Windows.Forms.Button
$btnProductivity.Text = "💼 Switch to Productivity Mode"
$btnProductivity.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$btnProductivity.BackColor = [System.Drawing.Color]::FromArgb(25, 118, 210)
$btnProductivity.ForeColor = [System.Drawing.Color]::White
$btnProductivity.FlatStyle = "Flat"
$btnProductivity.Location = New-Object System.Drawing.Point(50, 130)
$btnProductivity.Size = New-Object System.Drawing.Size(300, 50)
$btnProductivity.Add_Click({ Switch-ToProductivityMode })
$mainForm.Controls.Add($btnProductivity)

# Configuration Button
$btnConfig = New-Object System.Windows.Forms.Button
$btnConfig.Text = "⚙️ Configuration"
$btnConfig.Location = New-Object System.Drawing.Point(50, 200)
$btnConfig.Size = New-Object System.Drawing.Size(120, 30)
$btnConfig.Add_Click({ Show-ConfigForm })
$mainForm.Controls.Add($btnConfig)

# Exit Button
$btnExit = New-Object System.Windows.Forms.Button
$btnExit.Text = "Exit"
$btnExit.Location = New-Object System.Drawing.Point(230, 200)
$btnExit.Size = New-Object System.Drawing.Size(120, 30)
$btnExit.Add_Click({ $mainForm.Close() })
$mainForm.Controls.Add($btnExit)

# Show the form
$mainForm.ShowDialog()
