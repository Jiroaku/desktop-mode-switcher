# Desktop Switcher 🖥️⚡

A powerful Windows automation toolkit that lets you instantly switch between optimized desktop modes with zero hassle. Perfect for gamers, streamers, developers, and anyone who wants maximum performance on demand.

## 🎯 What It Does

- 🎮 **Gaming Mode** – Kills background apps, optimizes resolution, and maximizes performance for gaming
- 💼 **Productivity Mode** – Restores your full desktop environment with all your tools and customizations
- ⚡ **Instant Switching** – No UAC prompts, no delays, just double-click and go
- 🔧 **Fully Customizable** – Configure apps, resolutions, and behaviors to match your workflow

## 🚀 Key Features

- **Zero UAC Prompts** – Runs silently with admin privileges
- **Smart App Management** – Automatically closes/opens apps based on mode
- **Resolution Optimization** – Different resolutions for different use cases
- **Visual Notifications** – Know when modes switch with toast notifications
- **Audio Feedback** – Sound notifications for mode changes
- **GUI Interface** – Easy-to-use interface for configuration
- **Example Configs** – Pre-made configurations for different user types

## 📦 Quick Start

### 1. Download & Install

```powershell
# Clone the repository
git clone https://github.com/jiroaku/desktop-mode-switcher.git
cd desktop-mode-switcher

# Download NirCmd (required dependency)
# Visit: https://www.nirsoft.net/utils/nircmd.html
# Extract to: C:\Tools\NirCmd\
```

### 2. Run Setup

```powershell
# Right-click and "Run with PowerShell" as Administrator
.\scripts\Setup-GamingSwitcher.ps1
```

### 3. Use Desktop Shortcuts

After setup, you'll find two shortcuts on your desktop:
- 🎮 **Gaming Mode** – Optimizes for performance
- 💼 **Productivity Mode** – Restores full desktop

## 🎮 Usage Examples

### For Gamers
- **Gaming Mode**: Kills Discord, Spotify, browsers, and other apps
- **Productivity Mode**: Restores all your desktop tools and apps

### For Streamers
- **Streaming Mode**: Keeps OBS/Streamlabs running, closes distractions
- **Content Creation Mode**: Opens video editors, design tools, and productivity apps

### For Developers
- **Focus Mode**: Minimal distractions, just VS Code and terminal
- **Development Mode**: Full IDE, Docker, databases, and collaboration tools

## ⚙️ Configuration

### Using the GUI
```powershell
# Launch the configuration interface
.\scripts\DesktopSwitcher-GUI.ps1
```

### Manual Configuration
Edit `config.json` to customize:
- Apps to kill/start in each mode
- Resolution settings
- Notification preferences
- Sound settings

### Example Configurations
Check the `examples/` folder for pre-made configurations:
- `gamer-config.json` – Optimized for gaming
- `streamer-config.json` – Perfect for content creators
- `developer-config.json` – Ideal for coding sessions

## 🛠️ Advanced Usage

### Custom Scripts
You can add custom PowerShell commands to each mode:

```json
{
  "gaming_mode": {
    "custom_commands": [
      "Start-Process 'C:\\Games\\MyGame\\game.exe'",
      "Set-Volume -Volume 0.8"
    ]
  }
}
```

### Multiple Configurations
Create different config files for different scenarios:

```powershell
# Use a specific configuration
.\scripts\Setup-GamingSwitcher.ps1 -ConfigPath ".\examples\streamer-config.json"
```

## 🔧 Troubleshooting

### Common Issues

**"NirCmd not found"**
- Download NirCmd from: https://www.nirsoft.net/utils/nircmd.html
- Extract to `C:\Tools\NirCmd\` or update the path in config.json

**"Access denied" errors**
- Run PowerShell as Administrator
- Check that NirCmd is in the correct location

**Shortcuts not working**
- Verify scheduled tasks exist: `schtasks /Query /TN DesktopSwitcher-GamingMode`
- Re-run the setup script

**Apps not closing/opening**
- Check app names in Task Manager (exact process names)
- Update the configuration with correct process names

### Getting Help

1. Check the [Issues](https://github.com/jiroaku/desktop-mode-switcher/issues) page
2. Review the example configurations
3. Use the GUI to test your settings
4. Check Windows Event Viewer for detailed error messages

## 🗑️ Uninstallation

```powershell
# Remove all components
.\scripts\Uninstall-DesktopSwitcher.ps1
```

## 📁 Project Structure

```
desktop-mode-switcher/
├── scripts/
│   ├── Setup-GamingSwitcher.ps1    # Main setup script
│   ├── DesktopSwitcher-GUI.ps1     # GUI interface
│   └── Uninstall-DesktopSwitcher.ps1
├── examples/
│   ├── gamer-config.json           # Gaming-focused config
│   ├── streamer-config.json        # Streaming-focused config
│   └── developer-config.json       # Development-focused config
├── config.json                     # Default configuration
└── README.md
```

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Report Issues** – Found a bug? Let us know!
2. **Suggest Features** – Have an idea? We'd love to hear it!
3. **Submit Configs** – Share your custom configurations
4. **Improve Documentation** – Help others get started

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [NirCmd by NirSoft](https://www.nirsoft.net/utils/nircmd.html) for resolution management
- Windows Task Scheduler for silent execution
- PowerShell community for automation inspiration

## 🧠 Author

[@jiroaku](https://github.com/jiroaku)

---

**⭐ If this project helps you, please give it a star!**

