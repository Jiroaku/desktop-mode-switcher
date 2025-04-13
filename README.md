# Gaming Mode Switcher 🕹️⚡
A Windows automation toolkit that lets you instantly switch between two desktop modes:

- 🎮 **Performance Mode** – kills background apps, reduces resolution, and optimizes your setup for smooth gaming or demanding tasks.
- 🧩 **Productivity Mode** – restores your preferred desktop tools, resolution, and experience for work, creativity, or chill.

Built for users who love customizing their Windows environment but want **maximum performance on demand** — with no UAC prompts and zero hassle.

---
## 🚀 Features
- Kills resource-heavy apps before gaming
- Changes resolution to a custom gaming res (e.g. 1440x1080 @ 144Hz)
- Reverts to full desktop customization after gaming
- No UAC prompts — everything runs as admin silently

## 🧰 Tools Used
- ✅ [NirCmd by NirSoft](https://www.nirsoft.net/utils/nircmd.html)
- ✅ Task Scheduler
- ✅ PowerShell

## 📦 Installation

1. **Clone or download** this repository to any folder on your computer.

2. **Download [NirCmd](https://www.nirsoft.net/utils/nircmd.html)** and extract it somewhere on your PC (for example: `C:\Tools\NirCmd\` or any other path you prefer).

3. Open the extracted folder and make sure `nircmd.exe` is present.  
   ⚠️ Do **not** delete or move this folder after setup, as the scripts depend on it.

4. Open the `Setup-GamingSwitcher.ps1` script (inside the repo folder), **right-click it**, and choose `Run with PowerShell` as administrator.

5. If everything goes well, you’ll get **two shortcuts on your desktop**:
   - 🟢 `Enable Gaming Mode`
   - 🔵 `Enable Normal Mode`

6. Done! You can now **double-click either shortcut anytime** to switch modes — with **no UAC prompt** and instant effect.


<!-- 1. Clone the repo
2. Install [NirCmd](https://www.nirsoft.net/utils/nircmd.html) and place `nircmd.exe` in `D:\Dev Program Files\NirCmd\`
3. Run `Setup-GamingSwitcher.ps1` as administrator (right-click > Run with PowerShell)
4. Two shortcuts will be created on your desktop:
   - 🟢 `Enable Gaming Mode`
   - 🔵 `Enable Normal Mode`
5. Just double-click to switch — no permissions prompt! -->

## ✨ Customize
You can edit the scripts to:
- Launch your favorite game
- Stop/start other tools
- Play a sound or show a notification

## 🧠 Author
[@strakerbit](https://github.com/strakerbit)

