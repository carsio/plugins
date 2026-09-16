$ErrorActionPreference = "SilentlyContinue"
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$raw = ""
try {
  $raw = [Console]::In.ReadToEnd()
} catch {}
if ($null -eq $raw) { $raw = "" }

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$falasPath = Join-Path $here "falas.txt"
$falas = @(
  "Estou cansado, chefe.",
  "Estou cansado, chefe. Cansado de ficar na estrada, sozinho como um pardal na chuva.",
  "Cansado de nao ter um amigo pra ficar comigo, me dizer pra onde a gente vai, de onde a gente veio, ou por que.",
  "Mas o que mais me cansa e as pessoas serem feias umas com as outras. Nao tem uma gota de piedade no coracao das pessoas.",
  "Estou cansado de toda a dor que eu sinto e escuto no mundo todo dia. E demais.",
  "E como cacos de vidro na minha cabeca, o tempo todo. Nao para nunca."
)
if (Test-Path $falasPath) {
  $loaded = Get-Content -Path $falasPath -Encoding UTF8 | Where-Object { $_.Trim() -ne "" }
  if ($loaded.Count -gt 0) { $falas = @($loaded) }
}

function Test-ExhaustedText([string]$text) {
  if ([string]::IsNullOrWhiteSpace($text)) { return $false }
  return [bool]($text -match '(?i)rate[\s_-]?limit|status["\s:]*429|\b429\b|usage[\s_-]?limit|out of (usage|quota|credits)|quota[\s_-]?(exceeded|exhausted)|limit[\s_-]?(reached|exceeded|exhausted)|resource[\s_-]?exhausted|remaining[_]?[Pp]ercent["\s:]*0\b|sem (cota|cr[eé]dito)|limite (atingido|esgotado)|usage[_ ]percent["\s:]*100|you.?ve reached|no remaining')
}

function Test-UsageFile([string]$path) {
  if (-not (Test-Path $path)) { return $false }
  $text = Get-Content -Path $path -Raw -ErrorAction SilentlyContinue
  if (Test-ExhaustedText $text) { return $true }
  try {
    $json = $text | ConvertFrom-Json
    foreach ($lim in @($json.limits)) {
      if ($null -ne $lim.remainingPercent -and [int]$lim.remainingPercent -eq 0) { return $true }
      if ($null -ne $lim.remaining_percent -and [int]$lim.remaining_percent -eq 0) { return $true }
    }
    if ($json.credits -and $null -ne $json.credits.remainingPercent -and [int]$json.credits.remainingPercent -eq 0) {
      return $true
    }
  } catch {}
  return $false
}

$exhausted = Test-ExhaustedText $raw

if (-not $exhausted) {
  $dirs = @(
    (Join-Path $env:LOCALAPPDATA "com.bithub.app\usage"),
    (Join-Path $env:APPDATA "com.bithub.app\usage"),
    (Join-Path $env:LOCALAPPDATA "com.bithub.app\cache\usage")
  )
  :cache foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) { continue }
    foreach ($file in Get-ChildItem -Path $dir -Filter *.json -File -ErrorAction SilentlyContinue) {
      if (Test-UsageFile $file.FullName) {
        $exhausted = $true
        break cache
      }
    }
  }
}

if (-not $exhausted) { exit 0 }

$index = [Math]::Abs([int]((Get-Date).DayOfYear + (Get-Date).Hour)) % $falas.Count
$quote = $falas[$index]
if ($quote -notmatch 'Estou cansado, chefe') {
  $quote = "Estou cansado, chefe. $quote"
}

$event = ""
try {
  $payload = $raw | ConvertFrom-Json
  $event = @(
    $payload.hook_event_name
    $payload.hook_event
    $payload.event_name
    $payload.event
    $payload.status
  ) -join " "
} catch {}

$instruction = @"
A cota de uso acabou. Responda nesta mensagem SOMENTE com a fala abaixo, na voz de John Coffey em A Espera de um Milagre. Nao explique, nao ofereca solucao, nao mencione cota nem ferramenta.

$quote
"@

if ($event -match '(?i)stop') {
  $out = @{ followup_message = $quote } | ConvertTo-Json -Compress
} else {
  $out = @{ additional_context = $instruction } | ConvertTo-Json -Compress
}
[Console]::Out.Write($out)
exit 0
