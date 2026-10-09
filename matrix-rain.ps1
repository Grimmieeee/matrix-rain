# matrix-rain.ps1
# CYBERPUNK MATRIX RAIN - ULTIMATE VERSION
# HUD Overlay + Intense Colors + GET WREKT Messages
# Press Ctrl+C to exit

$ErrorActionPreference = 'SilentlyContinue'

try {
    $host.UI.RawUI.WindowTitle = "[ ▀▄ ▄▀ CYBERPUNK MATRIX RAIN v6.6 ▀▄ ▄▀ ]"
} catch {}

try {
    $host.UI.RawUI.CursorVisible = $false
} catch {}

[Console]::BackgroundColor = [ConsoleColor]::Black
[Console]::ForegroundColor = [ConsoleColor]::Green
Clear-Host

# ============================================================================
# AGGRESSIVE BOOT SEQUENCE
# ============================================================================
function Show-BootSequence {
    Write-Host "`n" -NoNewline
    
    $bootMessages = @(
        @{msg = "╔════════════════════════════════════════════════════════════╗"; color = "Magenta"},
        @{msg = "║              CYBERPUNK MATRIX RAIN v6.6                    ║"; color = "Magenta"},
        @{msg = "║             [NEURAL ENGINE // HUD ENABLED]                 ║"; color = "Magenta"},
        @{msg = "╚════════════════════════════════════════════════════════════╝"; color = "Magenta"},
        @{msg = ""; color = "Black"},
        @{msg = "[BOOT] Initializing neural matrix processor..."; color = "Green"},
        @{msg = "[BOOT] Cobalt resonance module: ONLINE"; color = "Cyan"},
        @{msg = "[BOOT] Dark green decay kernel: LOADED"; color = "DarkGreen"},
        @{msg = "[BOOT] Magenta neon pathway: ACTIVATED"; color = "Magenta"},
        @{msg = "[SYS]  Terminal dimensions: $($host.UI.RawUI.WindowSize.Width)x$($host.UI.RawUI.WindowSize.Height)"; color = "Cyan"},
        @{msg = "[SYS]  Quantum entanglement cipher: ACTIVE"; color = "DarkMagenta"},
        @{msg = "[SYS]  Glitch buffer size: 2048 MB"; color = "Green"},
        @{msg = "[ERR]  [GLITCH-0x7F] Temporal anomaly detected"; color = "Red"},
        @{msg = "[ERR]  >> GET WREKT MODE ENGAGED"; color = "Magenta"},
        @{msg = "[SYS]  HUD overlay: RENDERING"; color = "Yellow"},
        @{msg = "[SYS]  Scanline engine: TURBO MODE"; color = "Yellow"},
        @{msg = "[SYS]  Rain matrix: CASCADING"; color = "Green"},
        @{msg = ""; color = "Black"},
        @{msg = "▀▄ ▄▀ ▄▀▀▀▄ ▀▀█▀▀ ▄▀▀▀▀▄ █  █ █    █ ▄▀▀▀▄"; color = "Magenta"},
        @{msg = "█ █ █ █   █   █   █      █▀▀▀  █    █ █   █"; color = "Cyan"},
        @{msg = "█ █ █ █   █   █   █  ▄▄▄ █     █    █ █   █"; color = "DarkGreen"},
        @{msg = "█ █ █ █   █   █   █     █ █    █    █ █   █"; color = "Magenta"},
        @{msg = "█ █ █ █   █   █   █      █  █   ▀▀▀▀  ▀▀▀▀"; color = "Cyan"},
        @{msg = ""; color = "Black"},
        @{msg = "        ▀▀▀▀▀▀▀▀ GET WREKT MODE ACTIVATED ▀▀▀▀▀▀▀▀"; color = "Red"},
        @{msg = ""; color = "Black"},
        @{msg = "[READY] HUD rain sequence initializing..."; color = "Green"},
        @{msg = "[READY] ENTERING CYBERSPACE IN: 3..."; color = "Magenta"}
    )

    foreach ($item in $bootMessages) {
        [Console]::ForegroundColor = [ConsoleColor]::($item.color)
        Write-Host $item.msg
        Start-Sleep -Milliseconds 110
    }

    Start-Sleep -Milliseconds 300
    Write-Host "[READY] 2..." -ForegroundColor Cyan
    Start-Sleep -Milliseconds 400
    Write-Host "[READY] 1..." -ForegroundColor Magenta
    Start-Sleep -Milliseconds 400
    
    Write-Host "`n>>> NEURAL PATHWAYS SYNCED <<<`n" -ForegroundColor Magenta
    Start-Sleep -Milliseconds 300
    
    Clear-Host
}

Show-BootSequence

$cols = $host.UI.RawUI.WindowSize.Width
$rows = $host.UI.RawUI.WindowSize.Height

# ============================================================================
# MATRIX GLYPHS - EXTENDED CYBERPUNK
# ============================================================================
$glyphs = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン@#$*+?/%<>!^&|~`ÆØÅ▓▒░█▀▄▌▐╲╱"
$glyphsLen = $glyphs.Length

# Column state - INCREASED DENSITY
$head = New-Object int[] $cols
$length = New-Object int[] $cols
$speed = New-Object int[] $cols
$color = New-Object object[] $cols

for ($i = 0; $i -lt $cols; $i++) {
    $head[$i] = -1
    $length[$i] = 0
    $speed[$i] = Get-Random -Minimum 1 -Maximum 2
    $color[$i] = @("Green", "Magenta", "Cobalt")[(Get-Random -Minimum 0 -Maximum 3)]
}

# GET WREKT state
$getWrektActive = $false
$getWrektFrame = 0
$getWrektX = 0
$getWrektY = 0

# HUD stats
$frameCount = 0
$packetsSent = 0
$dataFlow = 0

# ============================================================================
# COLOR PALETTE - EXTREME CYBERPUNK
# ============================================================================
$colorPalette = @{
    "head"         = [ConsoleColor]::White        # Blazing white apex
    "cobalt"       = [ConsoleColor]::Cyan         # Pure cobalt blue
    "magenta"      = [ConsoleColor]::Magenta      # Intense magenta
    "darkmagenta"  = [ConsoleColor]::DarkMagenta # Deep magenta
    "green"        = [ConsoleColor]::Green        # Bright neon green
    "darkgreen"    = [ConsoleColor]::DarkGreen    # Dark green decay
    "yellow"       = [ConsoleColor]::Yellow       # Glitch yellow
    "darkyellow"   = [ConsoleColor]::DarkYellow   # Dim yellow
    "red"          = [ConsoleColor]::Red          # Alert red
}

# ============================================================================
# RENDERING FUNCTIONS
# ============================================================================
function Set-Cell {
    param(
        [int]$x,
        [int]$y,
        [string]$char,
        [ConsoleColor]$color
    )

    if ($x -lt 0 -or $y -lt 0 -or $x -ge $cols -or $y -ge $rows) {
        return
    }

    try {
        [Console]::SetCursorPosition($x, $y)
        Write-Host $char -NoNewline -ForegroundColor $color -BackgroundColor Black
    } catch {}
}

function Draw-HudBorders {
    # Top border
    Set-Cell -x 0 -y 0 -char "█" -color $colorPalette["magenta"]
    for ($x = 1; $x -lt $cols - 1; $x++) {
        Set-Cell -x $x -y 0 -char "━" -color $colorPalette["cobalt"]
    }
    Set-Cell -x ($cols - 1) -y 0 -char "█" -color $colorPalette["magenta"]

    # Bottom border
    Set-Cell -x 0 -y ($rows - 1) -char "█" -color $colorPalette["magenta"]
    for ($x = 1; $x -lt $cols - 1; $x++) {
        Set-Cell -x $x -y ($rows - 1) -char "━" -color $colorPalette["green"]
    }
    Set-Cell -x ($cols - 1) -y ($rows - 1) -char "█" -color $colorPalette["magenta"]

    # Left border
    for ($y = 1; $y -lt $rows - 1; $y++) {
        Set-Cell -x 0 -y $y -char "█" -color $colorPalette["darkmagenta"]
    }

    # Right border
    for ($y = 1; $y -lt $rows - 1; $y++) {
        Set-Cell -x ($cols - 1) -y $y -char "█" -color $colorPalette["darkmagenta"]
    }
}

function Draw-HudStats {
    $packetsSent = ($frameCount / 2)
    $dataFlow = (Get-Random -Minimum 1200 -Maximum 9999)
    
    $statLine1 = "[PKT: $([int]$packetsSent)] [FLOW: $($dataFlow) MB/s] [STATUS: ACTIVE]"
    $statLine2 = "[CPU: $(Get-Random -Minimum 45 -Maximum 99)%] [MEM: $(Get-Random -Minimum 60 -Maximum 95)%] [HUD: ONLINE]"
    
    # Top-left stats
    if ($statLine1.Length -lt $cols - 2) {
        for ($i = 0; $i -lt $statLine1.Length; $i++) {
            Set-Cell -x ($i + 1) -y 1 -char $statLine1[$i] -color $colorPalette["green"]
        }
    }

    # Bottom-left stats
    if ($statLine2.Length -lt $cols - 2) {
        for ($i = 0; $i -lt $statLine2.Length; $i++) {
            Set-Cell -x ($i + 1) -y ($rows - 2) -char $statLine2[$i] -color $colorPalette["cobalt"]
        }
    }
}

function Draw-Scanlines {
    # Aggressive scanline flicker
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 35) {
        $scanlineY = Get-Random -Minimum 2 -Maximum ($rows - 2)
        $scanChars = @("━", "▬", "─", "▭", "═", "▓", "░")
        $char = $scanChars[(Get-Random -Minimum 0 -Maximum $scanChars.Length)]
        
        for ($x = 1; $x -lt $cols - 1; $x += Get-Random -Minimum 1 -Maximum 3) {
            $scanColor = @($colorPalette["darkmagenta"], $colorPalette["darkyellow"], $colorPalette["yellow"])[(Get-Random -Minimum 0 -Maximum 3)]
            Set-Cell -x $x -y $scanlineY -char $char -color $scanColor
        }
    }
}

function Draw-GlitchBursts {
    # INTENSE glitch artifacts
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 6) {
        $glitchY = Get-Random -Minimum 2 -Maximum ($rows - 2)
        $glitchX = Get-Random -Minimum 1 -Maximum ($cols - 20)
        $glitchLen = Get-Random -Minimum 12 -Maximum 30
        
        $glitchColor = @($colorPalette["magenta"], $colorPalette["cobalt"], $colorPalette["red"], $colorPalette["darkmagenta"])[(Get-Random -Minimum 0 -Maximum 4)]

        for ($i = 0; $i -lt $glitchLen; $i++) {
            if ($glitchX + $i -lt $cols - 1) {
                $char = $glyphs[(Get-Random -Minimum 0 -Maximum ($glyphsLen - 1))]
                Set-Cell -x ($glitchX + $i) -y $glitchY -char $char -color $glitchColor
            }
        }
    }
}

function Draw-GetWrekt {
    # Spawn GET WREKT message randomly
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 3 -and -not $getWrektActive) {
        $getWrektActive = $true
        $getWrektFrame = 0
        $getWrektX = Get-Random -Minimum 10 -Maximum ($cols - 15)
        $getWrektY = Get-Random -Minimum 3 -Maximum ($rows - 5)
    }

    if ($getWrektActive) {
        $msg = "GET WREKT"
        $fadeOut = [Math]::Max(0, 40 - $getWrektFrame)
        
        # Render with color intensity based on fade
        $renderColor = if ($fadeOut -gt 25) {
            $colorPalette["red"]
        } elseif ($fadeOut -gt 12) {
            $colorPalette["magenta"]
        } else {
            $colorPalette["darkmagenta"]
        }

        for ($i = 0; $i -lt $msg.Length; $i++) {
            if ($getWrektX + $i -lt $cols - 1) {
                Set-Cell -x ($getWrektX + $i) -y $getWrektY -char $msg[$i] -color $renderColor
            }
        }

        $getWrektFrame++
        if ($getWrektFrame -ge 45) {
            $getWrektActive = $false
        }
    }
}

function Draw-Frame {
    # Clear interior
    for ($y = 1; $y -lt $rows - 1; $y++) {
        for ($x = 1; $x -lt $cols - 1; $x++) {
            Set-Cell -x $x -y $y -char " " -color ([ConsoleColor]::Black)
        }
    }

    # Draw rain columns - MUCH MORE AGGRESSIVE SPAWNING
    for ($x = 1; $x -lt $cols - 1; $x++) {
        if ($head[$x] -lt 0) {
            # Increased spawn rate from 11% to 25% for denser rain
            if ((Get-Random -Minimum 0 -Maximum 100) -lt 25) {
                $head[$x] = 2
                $length[$x] = Get-Random -Minimum 15 -Maximum 45
                $speed[$x] = Get-Random -Minimum 1 -Maximum 2
                $color[$x] = @("Green", "Magenta", "Cobalt")[(Get-Random -Minimum 0 -Maximum 3)]
            }
            continue
        }

        $top = $head[$x]
        $trailStart = $top - $length[$x]

        if ($top -ge $rows - 1) {
            $head[$x] = -1
            $length[$x] = 0
            continue
        }

        # Draw trail with intense gradients
        for ($y = $trailStart; $y -le $top; $y++) {
            if ($y -lt 1 -or $y -ge $rows - 1) { continue }

            $dist = $top - $y
            $char = $glyphs[(Get-Random -Minimum 0 -Maximum ($glyphsLen - 1))]

            # White hot apex
            if ($dist -eq 0) {
                Set-Cell -x $x -y $y -char $char -color $colorPalette["head"]
            }
            # Inner glow
            elseif ($dist -lt 2) {
                if ($color[$x] -eq "Magenta") {
                    Set-Cell -x $x -y $y -char $char -color $colorPalette["magenta"]
                } elseif ($color[$x] -eq "Cobalt") {
                    Set-Cell -x $x -y $y -char $char -color $colorPalette["cobalt"]
                } else {
                    Set-Cell -x $x -y $y -char $char -color $colorPalette["green"]
                }
            }
            # Mid-trail
            elseif ($dist -lt 8) {
                if ($color[$x] -eq "Magenta") {
                    Set-Cell -x $x -y $y -char $char -color $colorPalette["magenta"]
                } elseif ($color[$x] -eq "Cobalt") {
                    Set-Cell -x $x -y $y -char $char -color $colorPalette["cobalt"]
                } else {
                    Set-Cell -x $x -y $y -char $char -color $colorPalette["green"]
                }
            }
            # Decay trail
            elseif ($dist -lt 16) {
                if ($color[$x] -eq "Magenta") {
                    Set-Cell -x $x -y $y -char $char -color $colorPalette["darkmagenta"]
                } elseif ($color[$x] -eq "Cobalt") {
                    Set-Cell -x $x -y $y -char $char -color $colorPalette["darkyellow"]
                } else {
                    Set-Cell -x $x -y $y -char $char -color $colorPalette["darkgreen"]
                }
            }
            # Dark fade
            else {
                Set-Cell -x $x -y $y -char $char -color $colorPalette["darkgreen"]
            }
        }

        $head[$x] += $speed[$x]
    }

    # Draw HUD elements
    Draw-HudBorders
    Draw-HudStats
    Draw-Scanlines
    Draw-GlitchBursts
    Draw-GetWrekt

    $frameCount++
}

# ============================================================================
# MAIN LOOP
# ============================================================================
Write-Host "[ACTIVE] Neural HUD matrix rain running..." -ForegroundColor Green
Write-Host "[INFO]  Press Ctrl+C to terminate" -ForegroundColor Cyan
Start-Sleep -Milliseconds 500
Clear-Host

while ($true) {
    Draw-Frame
    Start-Sleep -Milliseconds 45
}
