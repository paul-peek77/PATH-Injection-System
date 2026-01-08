# Run this from your USB root (D:\)

# --- CONFIGURATION ---
$ShortcutFolder = "$PSScriptRoot\Shortcuts"
$ShimFolder     = "$PSScriptRoot\.bin"       

# ---------------------

# 1. Check if Shortcut folder exists
if (-not (Test-Path $ShortcutFolder)) {
    Write-Warning "Could not find folder: $ShortcutFolder"
    Write-Host "Please create a 'Shortcuts' folder and put your .lnk files there."
    Read-Host "Press Enter to exit..."
    exit
}

# 2. Prepare the .bin folder
# We use -Force to create it if missing, or return the existing one
New-Item -ItemType Directory -Path $ShimFolder -Force | Out-Null

# FIXED: Small pause for slow USB drives + Force check for hidden items
Start-Sleep -Milliseconds 200
$ShimDir = Get-Item -Path $ShimFolder -Force -ErrorAction SilentlyContinue
if ($ShimDir) {
    $ShimDir.Attributes = 'Hidden'
}

# Clean out old shims
Get-ChildItem -Path $ShimFolder -Filter "*.cmd" | Remove-Item -Force

# 3. Read Shortcuts and Link
$Shell = New-Object -ComObject WScript.Shell
$Shortcuts = Get-ChildItem -Path $ShortcutFolder -Filter *.lnk

Write-Host "Reading shortcuts from $ShortcutFolder..." -ForegroundColor Cyan

foreach ($lnk in $Shortcuts) {
    try {
        $ShortcutObj = $Shell.CreateShortcut($lnk.FullName)
        $TargetExe   = $ShortcutObj.TargetPath
        
        if (Test-Path $TargetExe) {
            # Create the clean command name (e.g. "gitbash.cmd")
            $BaseName = $lnk.BaseName.Replace(" ", "") 
            $ShimPath = "$ShimFolder\$BaseName.cmd"

            $Content = "@echo off`r`n`"$TargetExe`" %*"
            Set-Content -LiteralPath $ShimPath -Value $Content
            
            Write-Host "Linked: $BaseName -> $TargetExe" -ForegroundColor Gray
        }
        else {
            Write-Warning "Skipped '$($lnk.Name)' - Target not found."
        }
    }
    catch {
        Write-Warning "Error reading '$($lnk.Name)'"
    }
}

Write-Host "`nSUCCESS! Shortcuts synced to PATH." -ForegroundColor Green