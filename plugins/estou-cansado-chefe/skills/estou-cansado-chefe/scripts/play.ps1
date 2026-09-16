param(
  [string]$Path,
  [switch]$Wait
)

$ErrorActionPreference = "SilentlyContinue"

if ([string]::IsNullOrWhiteSpace($Path)) {
  $Path = Join-Path $PSScriptRoot "..\assets\eu-estou-cansado-chefe.mp3"
}

try {
  $Path = (Resolve-Path -LiteralPath $Path).Path
} catch {
  exit 1
}

if (-not (Test-Path -LiteralPath $Path)) { exit 1 }

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

try {
  Add-Type -AssemblyName PresentationCore | Out-Null
  $player = New-Object System.Windows.Media.MediaPlayer
  $player.Volume = 1
  $player.Open([uri]$Path)
  $player.Play()
  $deadline = (Get-Date).AddSeconds(8)
  while (-not $player.NaturalDuration.HasTimeSpan -and (Get-Date) -lt $deadline) {
    Start-Sleep -Milliseconds 80
  }
  if ($player.NaturalDuration.HasTimeSpan) {
    Start-Sleep -Milliseconds ([int]($player.NaturalDuration.TimeSpan.TotalMilliseconds + 400))
  } else {
    Start-Sleep -Seconds 6
  }
  $player.Stop()
  $player.Close()
  exit 0
} catch {}

try {
  $wmp = New-Object -ComObject WMPlayer.OCX
  $wmp.URL = $Path
  $wmp.settings.volume = 100
  $wmp.controls.play()
  Start-Sleep -Seconds 8
  $wmp.controls.stop()
  exit 0
} catch {}

Start-Process -FilePath $Path | Out-Null
exit 0
