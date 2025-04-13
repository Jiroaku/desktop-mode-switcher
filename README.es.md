# Cambiador de Modo de Escritorio ⚡🖥️

Un conjunto de scripts para Windows que te permite cambiar instantáneamente entre dos modos de escritorio:

- 🎮 **Modo de Rendimiento** – cierra apps en segundo plano, baja la resolución, y optimiza tu PC para juegos o tareas pesadas.
- 🧩 **Modo de Productividad** – restaura tus herramientas favoritas y tu resolución para trabajar, crear o simplemente disfrutar tu escritorio personalizado.

Diseñado para quienes personalizan su escritorio en Windows pero quieren **máximo rendimiento al instante** — sin permisos molestos y sin complicaciones.

---

## 🚀 Características
- Cierra programas pesados antes de jugar
- Cambia la resolución a una más ligera (1440x1080 @ 144Hz)
- Restaura la personalización después de jugar
- Todo se ejecuta como administrador, sin pedir permisos

## 🧰 Herramientas Utilizadas
- ✅ [NirCmd de NirSoft](https://www.nirsoft.net/utils/nircmd.html)
- ✅ Programador de tareas
- ✅ PowerShell

## 📦 Instalación

1. **Clona o descarga** este repositorio en cualquier carpeta de tu computadora.
2. **Descarga [NirCmd](https://www.nirsoft.net/utils/nircmd.html)** y extrae el contenido en una ruta de tu preferencia (por ejemplo: `C:\Tools\NirCmd\` o cualquier otra).
3. Asegúrate de que el archivo `nircmd.exe` esté dentro de esa carpeta.  
   ⚠️ **No elimines ni muevas esa carpeta** después de la instalación, ya que los scripts dependen de ella.
4. Abre el script `Setup-GamingSwitcher.ps1` (que está en la carpeta del repositorio), haz clic derecho y selecciona `Ejecutar con PowerShell` como administrador.
5. Si todo sale bien, se crearán **dos accesos directos en tu escritorio**:
   - 🟢 `Enable Gaming Mode`
   - 🔵 `Enable Normal Mode`
6. ¡Listo! Ahora puedes hacer **doble clic en cualquiera de los accesos directos** para cambiar de modo — sin pedir permisos y de forma instantánea.

## ✨ Personalización
Puedes editar los scripts para:
- Abrir automáticamente un juego
- Detener otros procesos
- Reproducir un sonido o mostrar una notificación

## 🧠 Autor
[@strakerbit](https://github.com/strakerbit)
