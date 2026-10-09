# matrix-rain.ps1
# CYBERPUNK MATRIX RAIN - CINEMATIC HEAVY RAIN VERSION
# Retro cyberpunk boot sequence + dense cascading rain
# Press Ctrl+C to exit

$ErrorActionPreference = 'SilentlyContinue'

try { $host.UI.RawUI.WindowTitle = "[ CYBERPUNK // MATRIX RAIN ]" } catch {}
try { $host.UI.RawUI.CursorVisible = $false } catch {}

[Console]::BackgroundColor = [ConsoleColor]::Black
[Console]::ForegroundColor = [ConsoleColor]::Green
Clear-Host

# ============================================================================
# CINEMATIC BOOT SEQUENCE
# ============================================================================
function Show-BootSequence {
    Write-Host ""
    Start-Sleep -Milliseconds 200
    
    $lines = @(
        @{ text = "╔════════════════════════════════════════════════════════════╗"; color = "DarkMagenta"; delay = 60 },
        @{ text = "║                                                            ║"; color = "DarkMagenta"; delay = 40 },
        @{ text = "║          ▄▀  ▀▄    █▀▀▀█   ▀▀█▀▀   █▀▀▀  █▀▀▀█          ║"; color = "Green"; delay = 80 },
        @{ text = "║          █    █    █       █      █      █              ║"; color = "Cyan"; delay = 80 },
        @{ text = "║          █    █    █▀▀▀    █      █▀▀▀  █▀▀▀█          ║"; color = "Magenta"; delay = 80 },
        @{ text = "║          █    █    █       █      █      █              ║"; color = "Green"; delay = 80 },
        @{ text = "║          ▀▀  ▀▀    █       █      █▀▀▀  █              ║"; color = "Cyan"; delay = 80 },
        @{ text = "║                                                            ║"; color = "DarkMagenta"; delay = 40 },
        @{ text = "║                    NEURAL RAIN ENGINE v7.2                ║"; color = "Magenta"; delay = 100 },
        @{ text = "║                                                            ║"; color = "DarkMagenta"; delay = 40 },
        @{ text = "╚════════════════════════════════════════════════════════════╝"; color = "DarkMagenta"; delay = 60 },
        @{ text = ""; color = "Black"; delay = 150 },
        @{ text = "[████████████████████████████] NEURAL KERNEL BOOT"; color = "Green"; delay = 120 },
        @{ text = "[████████████████████████████] COBALT PATHWAY SYNC"; color = "Cyan"; delay = 120 },
        @{ text = "[████████████████████████████] MAGENTA NEON INIT"; color = "Magenta"; delay = 120 },
        @{ text = "[████████████████████████████] DARK GREEN DECAY LOAD"; color = "DarkGreen"; delay = 120 },
        @{ text = ""; color = "Black"; delay = 100 },
        @{ text = "[••] RAIN MATRIX PROTOCOL ENGAGED"; color = "Green"; delay = 100 },
        @{ text = "[••] SCANLINE FLICKER READY"; color = "Cyan"; delay = 100 },
        @{ text = "[••] GLITCH ARTIFACTS PRIMED"; color = "Magenta"; delay = 100 },
        @{ text = "[••] TEMPORAL CASCADE ACTIVE"; color = "DarkMagenta"; delay = 100 },
        @{ text = ""; color = "Black"; delay = 150 },
        @{ text = "╔════════════════════════════════════════════════════════════╗"; color = "Magenta"; delay = 60 },
        @{ text = "║                  ENTERING CYBERSPACE IN...                 ║"; color = "Magenta"; delay = 100 },
        @{ text = "╚════════════════════════════════════════════════════════════╝"; color = "Magenta"; delay = 60 },
        @{ text = ""; color = "Black"; delay = 200 }
    )

    foreach ($line in $lines) {
        [Console]::ForegroundColor = [ConsoleColor]::($line.color)
        Write-Host $line.text
        Start-Sleep -Milliseconds $line.delay
    }

    # Countdown
    @(3, 2, 1) | ForEach-Object {
        Write-Host "                         [ $_ ]                          " -ForegroundColor Magenta
        Start-Sleep -Milliseconds 400
    }

    Write-Host ""
    Write-Host "                  ▀▀▀ RAIN SEQUENCE INITIATED ▀▀▀             " -ForegroundColor Cyan
    Start-Sleep -Milliseconds 500
    
    Clear-Host
}

Show-BootSequence

$cols = $host.UI.RawUI.WindowSize.Width
$rows = $host.UI.RawUI.WindowSize.Height

# ============================================================================
# GLYPHS
# ============================================================================
$glyphs = "ｦｱｳｴｵｶｷｸｹｺｻｼｽｾﾀﾁﾂﾃﾅﾆﾇﾈﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾗﾘﾙﾚﾜ"
$glyphsLen = $glyphs.Length

# ============================================================================
# RAIN STATE - OPTIMIZED FOR DENSITY
# ============================================================================
$rainColumns = @()
for ($i = 0; $i -lt $cols; $i++) {
    $rainColumns += @{
        x      = $i
        y      = -1
        length = 0
        speed  = Get-Random -Minimum 1 -Maximum 2
        kind   = @("green", "magenta", "cobalt")[(Get-Random -Minimum 0 -Maximum 3)]
        active = $false
    }
}

# ============================================================================
# RENDERING
# ============================================================================
function SetCell {
    param([int]$x, [int]$y, [string]$ch, [ConsoleColor]$col)
    if ($x -lt 0 -or $y -lt 0 -or $x -ge $cols -or $y -ge $rows) { return }
    try {
        [Console]::SetCursorPosition($x, $y)
        Write-Host $ch -NoNewline -ForegroundColor $col -BackgroundColor Black
    } catch {}
}

function ClearScreen {
    for ($y = 0; $y -lt $rows; $y++) {
        for ($x = 0; $x -lt $cols; $x++) {
            SetCell -x $x -y $y -ch " " -col ([ConsoleColor]::Black)
        }
    }
}

function DrawRain {
    foreach ($col in $rainColumns) {
        # Spawn new rain
        if (-not $col.active) {
            if ((Get-Random -Minimum 0 -Maximum 100) -lt 35) {
                $col.active = $true
                $col.y = 0
                $col.length = Get-Random -Minimum 18 -Maximum 50
                $col.speed = Get-Random -Minimum 1 -Maximum 2
                $col.kind = @("green", "magenta", "cobalt")[(Get-Random -Minimum 0 -Maximum 3)]
            }
            continue
        }

        # Draw column trail
        $trailStart = $col.y - $col.length
        for ($ty = $trailStart; $ty -le $col.y; $ty++) {
            if ($ty -lt 0 -or $ty -ge $rows) { continue }

            $dist = $col.y - $ty
            $glyph = $glyphs[(Get-Random -Minimum 0 -Maximum ($glyphsLen - 1))]

            # Head - bright white
            if ($dist -eq 0) {
                SetCell -x $col.x -y $ty -ch $glyph -col ([ConsoleColor]::White)
            }
            # Inner glow
            elseif ($dist -lt 4) {
                if ($col.kind -eq "magenta") {
                    SetCell -x $col.x -y $ty -ch $glyph -col ([ConsoleColor]::Magenta)
                }
                elseif ($col.kind -eq "cobalt") {
                    SetCell -x $col.x -y $ty -ch $glyph -col ([ConsoleColor]::Cyan)
                }
                else {
                    SetCell -x $col.x -y $ty -ch $glyph -col ([ConsoleColor]::Green)
                }
            }
            # Mid trail
            elseif ($dist -lt 12) {
                if ($col.kind -eq "magenta") {
                    SetCell -x $col.x -y $ty -ch $glyph -col ([ConsoleColor]::Magenta)
                }
                elseif ($col.kind -eq "cobalt") {
                    SetCell -x $col.x -y $ty -ch $glyph -col ([ConsoleColor]::DarkCyan)
                }
                else {
                    SetCell -x $col.x -y $ty -ch $glyph -col ([ConsoleColor]::Green)
                }
            }
            # Decay
            elseif ($dist -lt 20) {
                if ($col.kind -eq "magenta") {
                    SetCell -x $col.x -y $ty -ch $glyph -col ([ConsoleColor]::DarkMagenta)
                }
                elseif ($col.kind -eq "cobalt") {
                    SetCell -x $col.x -y $ty -ch $glyph -col ([ConsoleColor]::DarkGray)
                }
                else {
                    SetCell -x $col.x -y $ty -ch $glyph -col ([ConsoleColor]::DarkGreen)
                }
            }
            # Fade
            else {
                SetCell -x $col.x -y $ty -ch $glyph -col ([ConsoleColor]::DarkGreen)
            }
        }

        # Move down
        $col.y += $col.speed

        # Reset if off screen
        if ($col.y -ge $rows) {
            $col.active = $false
            $col.y = -1
            $col.length = 0
        }
    }
}

function DrawScanlines {
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 32) {
        $scanY = Get-Random -Minimum 0 -Maximum $rows
        $scanChars = @("━", "▬", "─", "═", "═", "═")
        $char = $scanChars[(Get-Random -Minimum 0 -Maximum $scanChars.Length)]

        for ($x = 0; $x -lt $cols; $x += (Get-Random -Minimum 1 -Maximum 3)) {
            $col = if ((Get-Random -Minimum 0 -Maximum 2) -eq 0) { [ConsoleColor]::DarkMagenta } else { [ConsoleColor]::DarkGray }
            SetCell -x $x -y $scanY -ch $char -col $col
        }
    }
}

function DrawGlitches {
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 5) {
        $glitchX = Get-Random -Minimum 0 -Maximum ($cols - 15)
        $glitchY = Get-Random -Minimum 0 -Maximum $rows
        $glitchLen = Get-Random -Minimum 10 -Maximum 25

        $glitchCol = @([ConsoleColor]::Magenta, [ConsoleColor]::Cyan, [ConsoleColor]::DarkMagenta)[(Get-Random -Minimum 0 -Maximum 3)]

        for ($i = 0; $i -lt $glitchLen; $i++) {
            if ($glitchX + $i -lt $cols) {
                $ch = $glyphs[(Get-Random -Minimum 0 -Maximum ($glyphsLen - 1))]
                SetCell -x ($glitchX + $i) -y $glitchY -ch $ch -col $glitchCol
            }
        }
    }
}

function DrawFrame {
    ClearScreen
    DrawRain
    DrawScanlines
    DrawGlitches
}

# ============================================================================
# MAIN LOOP
# ============================================================================
Write-Host "[SYSTEM] Rain matrix online..." -ForegroundColor Green
Write-Host "[SYSTEM] Cascade density: MAXIMUM" -ForegroundColor Cyan
Write-Host "[SYSTEM] Press Ctrl+C to terminate" -ForegroundColor Magenta
Start-Sleep -Milliseconds 800
Clear-Host

while ($true) {
    DrawFrame
    Start-Sleep -Milliseconds 40
}
