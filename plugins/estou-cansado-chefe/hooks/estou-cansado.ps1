$ErrorActionPreference = "SilentlyContinue"
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$raw = ""
try {
  $raw = [Console]::In.ReadToEnd()
} catch {}
if ($null -eq $raw) { $raw = "" }

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$pluginRoot = Split-Path -Parent $here
$falasPath = Join-Path $here "falas.txt"
$playScript = Join-Path $pluginRoot "skills\estou-cansado-chefe\scripts\play.ps1"
$audioPath = Join-Path $pluginRoot "skills\estou-cansado-chefe\assets\eu-estou-cansado-chefe.wav"
$stampPath = Join-Path $env:TEMP "estou-cansado-chefe.last"
$heavyRemaining = 40
$nearEndRemaining = 20
$contextPercent = 80
$cooldownSeconds = 720

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
  return [bool]($text -match '(?i)status["\s:]*429|\b429\b|out of (usage|quota|credits)|quota[\s_-]?(exceeded|exhausted)|limit[\s_-]?(reached|exceeded|exhausted)|resource[\s_-]?exhausted|remaining[_]?[Pp]ercent["\s:]*0\b|sem (cota|cr[eé]dito)|limite (atingido|esgotado)|usage[_ ]percent["\s:]*100|no remaining|(rate[\s_-]?limit|usage[\s_-]?limit)[\s_-]?(exceeded|reached)')
}

function Get-Number($value) {
  if ($null -eq $value) { return $null }
  try { return [double]$value } catch { return $null }
}

function Walk-Object($node, [scriptblock]$visit) {
  if ($null -eq $node) { return }
  if ($node -is [string] -or $node -is [ValueType]) { return }
  if ($node -is [System.Collections.IEnumerable] -and $node -isnot [string]) {
    foreach ($item in @($node)) { Walk-Object $item $visit }
    return
  }
  if ($null -eq $node.PSObject) { return }
  foreach ($prop in $node.PSObject.Properties) {
    & $visit $prop.Name $prop.Value
    Walk-Object $prop.Value $visit
  }
}

function Get-RemainingList($obj) {
  $vals = New-Object System.Collections.Generic.List[double]
  Walk-Object $obj {
    param($name, $value)
    $n = Get-Number $value
    if ($null -eq $n) { return }
    if ($name -match '(?i)remaining[_]?percent') { [void]$vals.Add($n) }
    elseif ($name -match '(?i)(used|usage)[_]?percent') { [void]$vals.Add(100.0 - $n) }
  }
  return @($vals)
}

function Test-ContextNear([string]$text, $obj, [string]$event) {
  if ($event -match '(?i)precompact|pre[_-]?compact') { return $true }
  if ($text -match '(?i)precompact|context (window )?(almost |nearly )?(full|limit)|compaction') { return $true }

  $script:contextHit = $false
  Walk-Object $obj {
    param($name, $value)
    if ($script:contextHit) { return }
    $n = Get-Number $value
    if ($null -eq $n) { return }
    if ($name -match '(?i)(context|window|token|prompt).*(percent|used|usage|ratio)' -or $name -match '(?i)(percent|used|usage).*(context|window|token)') {
      if ($n -ge $script:contextPercent) { $script:contextHit = $true }
    }
  }
  return [bool]$script:contextHit
}

function Read-UsageFile([string]$path) {
  if (-not (Test-Path $path)) { return $null }
  $text = Get-Content -Path $path -Raw -ErrorAction SilentlyContinue
  if ([string]::IsNullOrWhiteSpace($text)) { return $null }
  try { return $text | ConvertFrom-Json } catch { return $null }
}

$payload = $null
$event = ""
try {
  $payload = $raw | ConvertFrom-Json
  $event = @(
    $payload.hook_event_name
    $payload.hook_event
    $payload.event_name
    $payload.event
    $payload.status
    $payload.trigger
  ) -join " "
} catch {}

if (Test-ExhaustedText $raw) { exit 0 }

$remainings = New-Object System.Collections.Generic.List[double]
foreach ($n in Get-RemainingList $payload) { [void]$remainings.Add($n) }

$dirs = @(
  (Join-Path $env:LOCALAPPDATA "com.bithub.app\usage"),
  (Join-Path $env:APPDATA "com.bithub.app\usage"),
  (Join-Path $env:LOCALAPPDATA "com.bithub.app\cache\usage")
)
foreach ($dir in $dirs) {
  if (-not (Test-Path $dir)) { continue }
  foreach ($file in Get-ChildItem -Path $dir -Filter *.json -File -ErrorAction SilentlyContinue) {
    $usage = Read-UsageFile $file.FullName
    if ($null -eq $usage) { continue }
    $usageText = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
    if (Test-ExhaustedText $usageText) { continue }
    foreach ($n in Get-RemainingList $usage) { [void]$remainings.Add($n) }
  }
}

$positive = @($remainings | Where-Object { $_ -gt 0 })
$minRemaining = $null
if ($positive.Count -gt 0) { $minRemaining = ($positive | Measure-Object -Minimum).Minimum }

$nearEnd = ($null -ne $minRemaining -and $minRemaining -le $nearEndRemaining)
$heavy = ($null -ne $minRemaining -and $minRemaining -le $heavyRemaining)
$contextNear = Test-ContextNear $raw $payload $event

if (-not $heavy -and -not $nearEnd -and -not $contextNear) { exit 0 }

$now = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
if (Test-Path $stampPath) {
  try {
    $last = [int64]((Get-Content -Path $stampPath -Raw).Trim())
    if (($now - $last) -lt $cooldownSeconds) { exit 0 }
  } catch {}
}

if (Test-Path $playScript) {
  Start-Process -FilePath "powershell.exe" -WindowStyle Hidden -ArgumentList @(
    "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $playScript, "-Path", $audioPath
  ) | Out-Null
}

try { Set-Content -Path $stampPath -Value "$now" -Encoding ASCII } catch {}

$index = [Math]::Abs([int]((Get-Date).DayOfYear + (Get-Date).Hour)) % $falas.Count
$quote = $falas[$index]
if ($quote -notmatch 'Estou cansado, chefe') {
  $quote = "Estou cansado, chefe. $quote"
}

$reason = "uso alto"
if ($contextNear) { $reason = "janela de contexto perto do limite" }
elseif ($nearEnd) { $reason = "cota proxima do fim" }

$instruction = @"
O usuario esta com $reason. A cota AINDA NAO acabou. Toque o audio se ainda nao tocou. Dispare imediatamente o subagente john-coffey, cujo nome e John Coffey. Nao continue a tarefa principal nesta mensagem. Nao explique cota, contexto nem ferramenta. Se nao puder disparar o subagente, responda SOMENTE com a fala abaixo.

$quote
"@

if ($event -match '(?i)stop') {
  $out = @{ followup_message = $quote } | ConvertTo-Json -Compress
} else {
  $out = @{ additional_context = $instruction } | ConvertTo-Json -Compress
}
[Console]::Out.Write($out)
exit 0
