# Desktop Switcher Quick Start Guide

Get up and running with Desktop Switcher in 5 minutes!

## 🚀 Installation (2 minutes)

### 1. Download Dependencies
```powershell
# Download NirCmd (required)
# Visit: https://www.nirsoft.net/utils/nircmd.html
# Extract to: C:\Tools\NirCmd\
```

### 2. Run Setup
```powershell
# Right-click PowerShell → "Run as Administrator"
cd desktop-mode-switcher
.\scripts\Setup-GamingSwitcher.ps1
```

### 3. Done!
You'll see two shortcuts on your desktop:
- 🎮 **Gaming Mode**
- 💼 **Productivity Mode**

## ⚡ Usage (30 seconds)

Just double-click the shortcuts! No UAC prompts, instant switching.

## 🎯 Quick Configuration

### Using the GUI (Recommended)
```powershell
.\scripts\DesktopSwitcher-GUI.ps1
```

### Manual Configuration
Edit `config.json`:

```json
{
  "gaming_mode": {
    "processes_to_kill": [
      "Discord",
      "Spotify",
      "Chrome"
    ],
    "resolution": {
      "width": 1920,
      "height": 1080,
      "refresh_rate": 144
    }
  }
}
```

## 🎮 Example Use Cases

### For Gamers
- **Gaming Mode**: Kills Discord, Spotify, browsers
- **Productivity Mode**: Restores all desktop tools

### For Streamers
- **Streaming Mode**: Keeps OBS running, closes distractions
- **Content Mode**: Opens video editors and design tools

### For Developers
- **Focus Mode**: Just VS Code and terminal
- **Dev Mode**: Full IDE, Docker, collaboration tools

## 🔧 Troubleshooting

### Quick Fixes
```powershell
# Test system requirements
.\scripts\Test-SystemRequirements.ps1

# Reinstall if needed
.\scripts\Uninstall-DesktopSwitcher.ps1
.\scripts\Setup-GamingSwitcher.ps1
```

### Common Issues
- **"NirCmd not found"** → Download and extract to `C:\Tools\NirCmd\`
- **"Access denied"** → Run PowerShell as Administrator
- **Shortcuts not working** → Re-run setup script

## 📚 Next Steps

- Check out [example configurations](examples/) for different use cases
- Read the [full documentation](README.md) for advanced features
- See [troubleshooting guide](TROUBLESHOOTING.md) for detailed help

---

**That's it!** You're ready to switch between optimized desktop modes instantly. 🎉
