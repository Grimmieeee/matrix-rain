# matrix-rain.ps1
# CYBERPUNK MATRIX RAIN - FAST CHAOTIC BOOT + SPARSE RAIN
# Top-to-bottom cascade with mixed cool palette
# Press Ctrl+C to exit

$ErrorActionPreference = 'SilentlyContinue'

try { $host.UI.RawUI.WindowTitle = "[ CYBERPUNK // MATRIX RAIN ]" } catch {}
try { $host.UI.RawUI.CursorVisible = $false } catch {}

[Console]::BackgroundColor = [ConsoleColor]::Black
[Console]::ForegroundColor = [ConsoleColor]::Green
Clear-Host

# ============================================================================
# DUAL-STATE CHAOTIC BOOT - RAIN & BOOT FIGHTING FOR DOMINANCE
# ============================================================================
function Show-ChaoticBootSequence {
    $bootLines = @(
        "╔══════════════════════════════════════════════��════════════════╗",
        "║                                                               ║",
        "║          ▄▀  ▀▄    █▀▀▀█   ▀▀█▀▀   █▀▀▀  █▀▀▀█             ║",
        "║          █    █    █       █      █      █                  ║",
        "║          █    █    █▀▀▀    █      █▀▀▀  █▀▀▀█              ║",
        "║          █    █    █       █      █      █                  ║",
        "║          ▀▀  ▀▀    █       █      █▀▀▀  █                   ║",
        "║                                                               ║",
        "║                    NEURAL RAIN ENGINE v8.0                   ║",
        "║                                                               ║",
        "╚═══════════════════════════════════════════════════════════════╝"
    )

    $sysMessages = @(
        "[BOOT] Initializing rain matrix...",
        "[BOOT] Cobalt pathways online...",
        "[BOOT] Magenta neon synced...",
        "[BOOT] Dark green decay ready...",
        "[BOOT] Cascade engine: ACTIVE",
        "[RAIN] Neural lattice engaged...",
        "[RAIN] Scanline flicker: ONLINE",
        "[RAIN] Glitch artifacts: PRIMED"
    )

    $cols = $host.UI.RawUI.WindowSize.Width
    $rows = $host.UI.RawUI.WindowSize.Height
    $glyphs = "ｦｱｳｴｵｶｷｸｹｺｻｼｽｾﾀﾁﾂﾃﾅﾆﾇﾈﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾗﾘﾙﾚﾜ"
    $glyphsLen = $glyphs.Length

    function SetCell {
        param([int]$x, [int]$y, [string]$ch, [ConsoleColor]$col)
        if ($x -lt 0 -or $y -lt 0 -or $x -ge $cols -or $y -ge $rows) { return }
        try {
            [Console]::SetCursorPosition($x, $y)
            Write-Host $ch -NoNewline -ForegroundColor $col -BackgroundColor Black
        } catch {}
    }

    # Chaotic boot loop - boot and rain fighting
    for ($bootPhase = 0; $bootPhase -lt 35; $bootPhase++) {
        
        # Random chance to show boot message or rain
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 60) {
            # Show boot line
            $lineIdx = Get-Random -Minimum 0 -Maximum $bootLines.Length
            $bootLine = $bootLines[$lineIdx]
            $y = Get-Random -Minimum 2 -Maximum ($rows - 4)
            
            $colors = @([ConsoleColor]::Magenta, [ConsoleColor]::Cyan, [ConsoleColor]::Green, [ConsoleColor]::DarkMagenta)
            $col = $colors[(Get-Random -Minimum 0 -Maximum $colors.Length)]
            
            for ($i = 0; $i -lt $bootLine.Length; $i++) {
                SetCell -x $i -y $y -ch $bootLine[$i] -col $col
            }
        }
        
        # Always draw rain on top - chaotic overlay
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 70) {
            $rainColX = Get-Random -Minimum 0 -Maximum $cols
            $rainY = Get-Random -Minimum 0 -Maximum $rows
            $rainLen = Get-Random -Minimum 5 -Maximum 12
            
            for ($i = 0; $i -lt $rainLen; $i++) {
                $y = $rainY + $i
                if ($y -ge $rows) { break }
                
                $ch = $glyphs[(Get-Random -Minimum 0 -Maximum ($glyphsLen - 1))]
                $rainColors = @([ConsoleColor]::Green, [ConsoleColor]::Magenta, [ConsoleColor]::Cyan, [ConsoleColor]::White, [ConsoleColor]::DarkCyan)
                $rainColC = $rainColors[(Get-Random -Minimum 0 -Maximum $rainColors.Length)]
                
                SetCell -x $rainColX -y $y -ch $ch -col $rainColC
            }
        }

        # Draw random sys message
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 35) {
            $msgIdx = Get-Random -Minimum 0 -Maximum $sysMessages.Length
            $msg = $sysMessages[$msgIdx]
            $msgY = Get-Random -Minimum 0 -Maximum ($rows - 1)
            
            $msgColors = @([ConsoleColor]::Green, [ConsoleColor]::Cyan, [ConsoleColor]::Magenta)
            $msgCol = $msgColors[(Get-Random -Minimum 0 -Maximum $msgColors.Length)]
            
            for ($i = 0; $i -lt $msg.Length -and $i -lt $cols; $i++) {
                SetCell -x $i -y $msgY -ch $msg[$i] -col $msgCol
            }
        }

        # Scanline glitch
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 30) {
            $scanY = Get-Random -Minimum 0 -Maximum $rows
            for ($x = 0; $x -lt $cols; $x += 3) {
                SetCell -x $x -y $scanY -ch "▬" -col ([ConsoleColor]::DarkMagenta)
            }
        }

        Start-Sleep -Milliseconds 70
    }

    Start-Sleep -Milliseconds 300
    Write-Host "`n>>> NEURAL SYNC COMPLETE <<<`n" -ForegroundColor Cyan
    Start-Sleep -Milliseconds 300
    Clear-Host
}

Show-ChaoticBootSequence

$cols = $host.UI.RawUI.WindowSize.Width
$rows = $host.UI.RawUI.WindowSize.Height

# ============================================================================
# KATAKANA GLYPHS
# ============================================================================
$glyphs = "ｦｱｳｴｵｶｷｸｹｺｻｼｽｾﾀﾁﾂﾃﾅﾆﾇﾈﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾗﾘﾙﾚﾜ"
$glyphsLen = $glyphs.Length

# ============================================================================
# RAIN COLUMNS - TOP TO BOTTOM, SPARSE
# ============================================================================
$columns = New-Object object[] $cols

for ($i = 0; $i -lt $cols; $i++) {
    $columns[$i] = @{
        y        = -1
        length   = 0
        kind     = @("green", "magenta", "cobalt")[(Get-Random -Minimum 0 -Maximum 3)]
        speed    = Get-Random -Minimum 2 -Maximum 4
        countdown = Get-Random -Minimum 3 -Maximum 8
    }
}

function SetCell {
    param([int]$x, [int]$y, [string]$ch, [ConsoleColor]$col)
    if ($x -lt 0 -or $y -lt 0 -or $x -ge $cols -or $y -ge $rows) { return }
    try {
        [Console]::SetCursorPosition($x, $y)
        Write-Host $ch -NoNewline -ForegroundColor $col -BackgroundColor Black
    } catch {}
}

function DrawFrame {
    # Sparse column activation - less dense
    for ($x = 0; $x -lt $cols; $x++) {
        $col = $columns[$x]

        # Countdown to spawn
        if ($col.countdown -gt 0) {
            $col.countdown--
            if ($col.countdown -eq 0) {
                $col.y = 0
                $col.length = Get-Random -Minimum 8 -Maximum 20
                $col.kind = @("green", "magenta", "cobalt")[(Get-Random -Minimum 0 -Maximum 3)]
                $col.speed = Get-Random -Minimum 2 -Maximum 4
            }
            continue
        }

        # Only draw if active
        if ($col.y -ge 0) {
            # Draw trail from top down
            for ($dy = 0; $dy -lt $col.length; $dy++) {
                $screenY = $col.y - $dy

                if ($screenY -lt 0) { continue }
                if ($screenY -ge $rows) { continue }

                $dist = $dy
                $ch = $glyphs[(Get-Random -Minimum 0 -Maximum ($glyphsLen - 1))]

                # Head - bright white
                if ($dist -eq 0) {
                    SetCell -x $x -y $screenY -ch $ch -col ([ConsoleColor]::White)
                }
                # Bright glow
                elseif ($dist -lt 2) {
                    if ($col.kind -eq "magenta") {
                        SetCell -x $x -y $screenY -ch $ch -col ([ConsoleColor]::Magenta)
                    }
                    elseif ($col.kind -eq "cobalt") {
                        SetCell -x $x -y $screenY -ch $ch -col ([ConsoleColor]::Cyan)
                    }
                    else {
                        SetCell -x $x -y $screenY -ch $ch -col ([ConsoleColor]::Green)
                    }
                }
                # Mid trail
                elseif ($dist -lt 6) {
                    if ($col.kind -eq "magenta") {
                        SetCell -x $x -y $screenY -ch $ch -col ([ConsoleColor]::Magenta)
                    }
                    elseif ($col.kind -eq "cobalt") {
                        SetCell -x $x -y $screenY -ch $ch -col ([ConsoleColor]::DarkCyan)
                    }
                    else {
                        SetCell -x $x -y $screenY -ch $ch -col ([ConsoleColor]::Green)
                    }
                }
                # Decay
                else {
                    if ($col.kind -eq "magenta") {
                        SetCell -x $x -y $screenY -ch $ch -col ([ConsoleColor]::DarkMagenta)
                    }
                    elseif ($col.kind -eq "cobalt") {
                        SetCell -x $x -y $screenY -ch $ch -col ([ConsoleColor]::DarkGray)
                    }
                    else {
                        SetCell -x $x -y $screenY -ch $ch -col ([ConsoleColor]::DarkGreen)
                    }
                }
            }

            # Move down fast
            $col.y += $col.speed

            # Reset when off-screen
            if ($col.y -ge $rows) {
                $col.y = -1
                $col.length = 0
                $col.countdown = Get-Random -Minimum 5 -Maximum 12
            }
        }
    }

    # Occasional scanline
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 15) {
        $scanY = Get-Random -Minimum 0 -Maximum $rows
        for ($x = 0; $x -lt $cols; $x += 4) {
            SetCell -x $x -y $scanY -ch "▬" -col ([ConsoleColor]::DarkMagenta)
        }
    }

    # Random glitch burst
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 2) {
        $x0 = Get-Random -Minimum 0 -Maximum ($cols - 10)
        $y = Get-Random -Minimum 0 -Maximum $rows
        for ($i = 0; $i -lt 10; $i++) {
            $ch = $glyphs[(Get-Random -Minimum 0 -Maximum ($glyphsLen - 1))]
            SetCell -x ($x0 + $i) -y $y -ch $ch -col ([ConsoleColor]::Magenta)
        }
    }
}

# ============================================================================
# MAIN LOOP - FAST & SPARSE
# ============================================================================
Write-Host "[RAIN] Cascade online..." -ForegroundColor Green
Write-Host "[RAIN] Cool palette: ACTIVE" -ForegroundColor Cyan
Start-Sleep -Milliseconds 200
Clear-Host

while ($true) {
    DrawFrame
    Start-Sleep -Milliseconds 15
}
