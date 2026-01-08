# PATH Injection System v1.0

This project is provided for portfolio review only. No permission is granted for reuse, modification, or redistribution.

OVERVIEW

The Windows PATH Injection System is a simple, portable workflow for exposing applications to the command line without installing them or modifying system‑level PATH variables. It uses a folder of Windows shortcuts (.lnk files) to generate lightweight command shims (.cmd files) inside a hidden .bin directory. These shims allow portable applications to be invoked from any terminal session.

The system is designed for use on portable drives and constrained Windows environments where installation is not possible or not desired.

HOW IT WORKS

The workflow is intentionally minimal and declarative:

1. You place .lnk shortcuts to your portable applications inside the Shortcuts folder.
2. You run Update-Portables.ps1 (or UPDATE.bat as a convenience wrapper).
3. The script:
   - reads each shortcut
   - extracts the target executable path
   - generates a .cmd shim in the .bin directory
   - hides the .bin directory for cleanliness
4. Your PATH is updated externally (e.g., via your shell profile or launcher) to include the .bin directory.
5. Any shim inside .bin becomes a callable command.

REVERSING OR UPDATING THE PATH

There is no special reversible mechanism. The system is declarative:

- Whatever shortcuts exist in the Shortcuts folder become the PATH commands.
- If you remove a shortcut and run the script again, the shim disappears.
- If you add a shortcut and run the script again, a new shim appears.

The script is the source of truth.
The PATH reflects the current state of the Shortcuts folder.

KEY FEATURES

- No installation required — ideal for portable drives and restricted systems
- No permanent PATH modification — the .bin directory is the only PATH dependency
- Shortcut‑driven design — the user controls available commands by adding or removing .lnk files
- Automatic shim generation — .cmd wrappers are created for each shortcut
- Safe and simple — no registry edits, no system writes, no elevated permissions

USAGE

1. Place your portable applications anywhere on your drive.
2. Create .lnk shortcuts to those executables.
3. Put the shortcuts into the Shortcuts folder.
4. Run UPDATE.bat or Update-Portables.ps1.
5. Ensure .bin is included in your PATH (manually or via your shell profile).
6. Call your apps from the terminal using the shortcut names (spaces removed).

PURPOSE

This project demonstrates:
- practical scripting
- filesystem automation
- COM‑based shortcut parsing
- portable workflow design
- safe, non‑destructive environment configuration

It is part of a larger portfolio showcasing systems thinking, developer tooling, and workflow engineering.
