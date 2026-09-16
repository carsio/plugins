param(
  [string]$Path,
  [switch]$Wait
)

$ErrorActionPreference = "SilentlyContinue"

function Get-AudioPath {
  param([string]$Preferred)
  $dir = Join-Path $PSScriptRoot "..\assets"
  $candidates = @()
  if (-not [string]::IsNullOrWhiteSpace($Preferred)) { $candidates += $Preferred }
  $candidates += @(
    (Join-Path $dir "eu-estou-cansado-chefe.wav"),
    (Join-Path $dir "eu-estou-cansado-chefe.mp3"),
    (Join-Path $dir "eu-estou-cansado-chefe.mpeg")
  )
  foreach ($item in $candidates) {
    if (Test-Path -LiteralPath $item) {
      return (Resolve-Path -LiteralPath $item).Path
    }
  }
  return $null
}

$Path = Get-AudioPath -Preferred $Path
if ([string]::IsNullOrWhiteSpace($Path)) { exit 1 }

if (-not $Wait) {
  Start-Process -FilePath "powershell.exe" -WindowStyle Hidden -ArgumentList @(
    "-NoProfile",
    "-STA",
    "-ExecutionPolicy", "Bypass",
    "-File", $PSCommandPath,
    "-Path", $Path,
    "-Wait"
  ) | Out-Null
  exit 0
}

if ($Path -match '\.wav$') {
  try {
    $player = New-Object System.Media.SoundPlayer
    $player.SoundLocation = $Path
    $player.Load()
    $player.PlaySync()
    exit 0
  } catch {}
}

$ffplay = Get-Command ffplay.exe -ErrorAction SilentlyContinue
if ($ffplay) {
  & $ffplay.Source -nodisp -autoexit -loglevel quiet -- $Path
  if ($LASTEXITCODE -eq 0) { exit 0 }
}

try {
  $code = @"
using System;
using System.Text;
using System.Runtime.InteropServices;
public static class CansadoMci {
  [DllImport("winmm.dll", CharSet = CharSet.Unicode)]
  public static extern int mciSendString(string command, StringBuilder returnValue, int returnLength, IntPtr hwndCallback);
}
"@
  Add-Type -TypeDefinition $code -ErrorAction Stop
  $alias = "cansado" + [Guid]::NewGuid().ToString("N").Substring(0, 8)
  [void][CansadoMci]::mciSendString("open `"$Path`" type mpegvideo alias $alias", $null, 0, [IntPtr]::Zero)
  [void][CansadoMci]::mciSendString("play $alias wait", $null, 0, [IntPtr]::Zero)
  [void][CansadoMci]::mciSendString("close $alias", $null, 0, [IntPtr]::Zero)
  exit 0
} catch {}

exit 1
