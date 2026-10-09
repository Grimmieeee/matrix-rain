# matrix-rain.ps1
# CYBERPUNK MATRIX RAIN - CINEMATIC TERMINAL STARTUP
# Boot sequence that transitions into heavy rain cascade
# Press Ctrl+C to exit

$ErrorActionPreference = 'SilentlyContinue'

try { $host.UI.RawUI.WindowTitle = "[ CYBERPUNK // MATRIX RAIN ]" } catch {}
try { $host.UI.RawUI.CursorVisible = $false } catch {}

[Console]::BackgroundColor = [ConsoleColor]::Black
[Console]::ForegroundColor = [ConsoleColor]::Green
Clear-Host

$cols = $host.UI.RawUI.WindowSize.Width
$rows = $host.UI.RawUI.WindowSize.Height

$glyphs = "ｦｱｳｴｵｶｷｸｹｺｻｼｽｾﾀﾁﾂﾃﾅﾆﾇﾈﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾗﾘﾙﾚﾜ"
$glyphsLen = $glyphs.Length

# ============================================================
# SCREEN BUFFER
# ============================================================
$screenBuffer = New-Object 'object[,]' $rows, $cols

function SetCell {
    param([int]$x, [int]$y, [string]$ch, [ConsoleColor]$col)
    if ($x -lt 0 -or $y -lt 0 -or $x -ge $cols -or $y -ge $rows) { return }
    try {
        [Console]::SetCursorPosition($x, $y)
        Write-Host $ch -NoNewline -ForegroundColor $col -BackgroundColor Black
    } catch {}
}

function ClearBuffer {
    for ($y = 0; $y -lt $rows; $y++) {
        for ($x = 0; $x -lt $cols; $x++) {
            SetCell -x $x -y $y -ch " " -col ([ConsoleColor]::Black)
        }
    }
}

# ============================================================
# BOOT SEQUENCE WITH HEAVY RAIN OVERLAY
# ============================================================
function Boot-Cinematic {
    $bootLines = @(
        "╔════════════════════════════════════════════════════════════╗",
        "║                                                            ║",
        "║          ▄▀  ▀▄    █▀▀▀█   ▀▀█▀▀   █▀▀▀  █▀▀▀█          ║",
        "║          █    █    █       █      █      █              ║",
        "║          █    █    █▀▀▀    █      █▀▀▀  █▀▀▀█          ║",
        "║          █    █    █       █      █      █              ║",
        "║          ▀▀  ▀▀    █       █      █▀▀▀  █              ║",
        "║                                                            ║",
        "║                  NEURAL RAIN ENGINE v8.0                 ║",
        "║                    [CYBERPUNK TERMINAL]                   ║",
        "║                                                            ║",
        "╚════════════════════════════════════════════════════════════╝"
    )

    $messages = @(
        "[INIT] Loading neural matrix...",
        "[SYNC] Cobalt pathway activated...",
        "[SYNC] Magenta mesh online...",
        "[SYNC] Green decay lattice ready...",
        "[BOOT] Rain cascade engine initialized",
        "[BOOT] Scanline flicker system: ONLINE",
        "[BOOT] Entering terminal rain mode...",
        "[READY] System cascade: ACTIVE"
    )

    # 4-second boot with rain fighting for dominance
    for ($frame = 0; $frame -lt 260; $frame++) {
        ClearBuffer

        $bootIdx = [Math]::Floor($frame / 30)
        if ($bootIdx -ge 0 -and $bootIdx -lt $bootLines.Length) {
            $bootLine = $bootLines[$bootIdx]
            $bootY = [Math]::Floor($rows / 2) - ([Math]::Floor($bootLines.Length / 2)) + $bootIdx
            
            if ($bootY -ge 0 -and $bootY -lt $rows) {
                $bootColor = @([ConsoleColor]::Magenta, [ConsoleColor]::Cyan, [ConsoleColor]::Green)[(Get-Random -Minimum 0 -Maximum 3)]
                for ($x = 0; $x -lt $bootLine.Length; $x++) {
                    SetCell -x $x -y $bootY -ch $bootLine[$x] -col $bootColor
                }
            }
        }

        # Boot message at bottom
        $msgIdx = [Math]::Floor($frame / 30)
        if ($msgIdx -ge 0 -and $msgIdx -lt $messages.Length) {
            $msg = $messages[$msgIdx]
            $msgY = $rows - 3
            $msgColor = @([ConsoleColor]::Green, [ConsoleColor]::Cyan, [ConsoleColor]::Magenta)[(Get-Random -Minimum 0 -Maximum 3)]
            for ($x = 0; $x -lt $msg.Length -and $x -lt $cols; $x++) {
                SetCell -x $x -y $msgY -ch $msg[$x] -col $msgColor
            }
        }

        # HEAVY RAIN OVERLAY - constantly fighting with boot text
        for ($rainCol = 0; $rainCol -lt $cols; $rainCol++) {
            if ((Get-Random -Minimum 0 -Maximum 100) -lt 40) {
                $rainLen = Get-Random -Minimum 6 -Maximum 16
                $rainY = Get-Random -Minimum 0 -Maximum ($rows - 4)

                for ($i = 0; $i -lt $rainLen; $i++) {
                    $y = $rainY + $i
                    if ($y -ge $rows) { break }

                    $ch = $glyphs[(Get-Random -Minimum 0 -Maximum $glyphsLen)]
                    $rainColor = @([ConsoleColor]::Green, [ConsoleColor]::Magenta, [ConsoleColor]::Cyan, [ConsoleColor]::DarkCyan, [ConsoleColor]::White)[(Get-Random -Minimum 0 -Maximum 5)]
                    SetCell -x $rainCol -y $y -ch $ch -col $rainColor
                }
            }
        }

        # Scanline flicker during boot
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 25) {
            $scanY = Get-Random -Minimum 0 -Maximum $rows
            for ($x = 0; $x -lt $cols; $x += 2) {
                SetCell -x $x -y $scanY -ch "▬" -col ([ConsoleColor]::DarkMagenta)
            }
        }

        Start-Sleep -Milliseconds 15
    }

    Write-Host "`n>>> CYBERSPACE INITIALIZED <<<`n" -ForegroundColor Cyan
    Start-Sleep -Milliseconds 300
    ClearBuffer
}

Boot-Cinematic

# ============================================================
# RAIN MODE - PURE CASCADE
# ============================================================
$rainColumns = @()
for ($i = 0; $i -lt $cols; $i++) {
    $rainColumns += @{
        y = -1
        trail = @()
        kind = @("green", "magenta", "cobalt")[(Get-Random -Minimum 0 -Maximum 3)]
        speed = Get-Random -Minimum 1 -Maximum 3
        active = $false
    }
}

function DrawRain {
    ClearBuffer

    for ($x = 0; $x -lt $cols; $x++) {
        $col = $rainColumns[$x]

        # Spawn new column
        if (-not $col.active) {
            if ((Get-Random -Minimum 0 -Maximum 100) -lt 22) {
                $col.active = $true
                $col.y = 0
                $col.trail = @()
                $col.kind = @("green", "magenta", "cobalt", "mixed")[(Get-Random -Minimum 0 -Maximum 4)]
                $col.speed = Get-Random -Minimum 1 -Maximum 3
            }
            continue
        }

        # Build trail
        if ($col.trail.Count -lt (Get-Random -Minimum 16 -Maximum 28)) {
            $col.trail += @($glyphs[(Get-Random -Minimum 0 -Maximum $glyphsLen)])
        }

        # Draw trail from head down
        for ($i = 0; $i -lt $col.trail.Count; $i++) {
            $screenY = $col.y + $i
            if ($screenY -lt 0 -or $screenY -ge $rows) { continue }

            $ch = $col.trail[$i]
            $dist = $i

            if ($dist -eq 0) {
                SetCell -x $x -y $screenY -ch $ch -col ([ConsoleColor]::White)
            }
            elseif ($dist -lt 2) {
                if ($col.kind -eq "magenta") { $c = [ConsoleColor]::Magenta }
                elseif ($col.kind -eq "cobalt") { $c = [ConsoleColor]::Cyan }
                elseif ($col.kind -eq "mixed") { $c = [ConsoleColor]::DarkCyan }
                else { $c = [ConsoleColor]::Green }
                SetCell -x $x -y $screenY -ch $ch -col $c
            }
            elseif ($dist -lt 6) {
                if ($col.kind -eq "magenta") { $c = [ConsoleColor]::Magenta }
                elseif ($col.kind -eq "cobalt") { $c = [ConsoleColor]::Cyan }
                elseif ($col.kind -eq "mixed") { $c = [ConsoleColor]::DarkCyan }
                else { $c = [ConsoleColor]::Green }
                SetCell -x $x -y $screenY -ch $ch -col $c
            }
            elseif ($dist -lt 12) {
                if ($col.kind -eq "magenta") { $c = [ConsoleColor]::DarkMagenta }
                elseif ($col.kind -eq "cobalt") { $c = [ConsoleColor]::DarkCyan }
                elseif ($col.kind -eq "mixed") { $c = [ConsoleColor]::DarkGreen }
                else { $c = [ConsoleColor]::DarkGreen }
                SetCell -x $x -y $screenY -ch $ch -col $c
            }
            else {
                SetCell -x $x -y $screenY -ch $ch -col ([ConsoleColor]::DarkGreen)
            }
        }

        # Move down
        $col.y += $col.speed

        # Reset when off-screen
        if (($col.y + $col.trail.Count) -ge $rows) {
            $col.active = $false
            $col.y = -1
            $col.trail = @()
        }
    }

    # Scanlines
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 18) {
        $scanY = Get-Random -Minimum 0 -Maximum $rows
        $scanChars = @("━", "▬", "─", "═")
        for ($x = 0; $x -lt $cols; $x += 3) {
            SetCell -x $x -y $scanY -ch $scanChars[(Get-Random -Minimum 0 -Maximum $scanChars.Length)] -col ([ConsoleColor]::DarkMagenta)
        }
    }

    # Glitch bursts
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 4) {
        $glitchX = Get-Random -Minimum 0 -Maximum ($cols - 12)
        $glitchY = Get-Random -Minimum 0 -Maximum $rows
        $glitchLen = Get-Random -Minimum 8 -Maximum 18
        $glitchColor = @([ConsoleColor]::Magenta, [ConsoleColor]::Cyan, [ConsoleColor]::Green)[(Get-Random -Minimum 0 -Maximum 3)]
        for ($i = 0; $i -lt $glitchLen; $i++) {
            if ($glitchX + $i -lt $cols) {
                $ch = $glyphs[(Get-Random -Minimum 0 -Maximum $glyphsLen)]
                SetCell -x ($glitchX + $i) -y $glitchY -ch $ch -col $glitchColor
            }
        }
    }
}

# ============================================================
# MAIN RAIN LOOP
# ============================================================
Write-Host "[RAIN] Neural cascade online" -ForegroundColor Green
Write-Host "[RAIN] Density: SPARSE | Speed: FAST" -ForegroundColor Cyan
Start-Sleep -Milliseconds 200
ClearBuffer

while ($true) {
    DrawRain
    Start-Sleep -Milliseconds 15
}
