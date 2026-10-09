# matrix-rain.ps1
# CYBERPUNK MATRIX RAIN - Retro Terminal Effect
# Press Ctrl+C to exit
# Fixed for PowerShell 7+ and Windows PowerShell

$ErrorActionPreference = 'SilentlyContinue'

# Clear any errors
$null = Get-Error -ErrorAction SilentlyContinue

$host.UI.RawUI.WindowTitle = "[ CYBERPUNK // MATRIX RAIN INITIALIZED ]"

# Try to hide cursor (works on some systems)
try {
    [Console]::CursorVisible = $false
} catch {
    # Fallback if cursor control unavailable
}

[Console]::BackgroundColor = [ConsoleColor]::Black
[Console]::ForegroundColor = [ConsoleColor]::Green
Clear-Host

# ============================================================================
# STARTUP BOOT SEQUENCE
# ============================================================================
function Show-BootSequence {
    $bootMessages = @(
        "[ SYSTEM ] NEURAL MATRIX INITIALIZED",
        "[ LOADING ] CYBERPUNK RAIN ENGINE v4.2",
        "[ CHECK ] TERMINAL DIMENSIONS: $($host.UI.RawUI.WindowSize.Width)x$($host.UI.RawUI.WindowSize.Height)",
        "[ CRYPTO ] INITIALIZING GLITCH BUFFER...",
        "[ SYNC ] ALIGNING NEON PATHWAYS...",
        "[ READY ] RAIN SEQUENCE COMMENCING IN 3...",
        "",
        "▀▄ ▄▀ ▄▀▀▀▄ ▀▀█▀▀ ▄▀▀▀▀▄ █  █ █    █ ▄▀▀▀▄",
        "█ █ █ █   █   █   █      █▀▀▀  █    █ █   █",
        "█ █ █ █   █   █   █  ▄▄▄ █     █    █ █   █",
        "█ █ █ █   █   █   █     █ █    █    █ █   █",
        "█ █ █ █   █   █   █      █  █   ▀▀▀▀  ▀▀▀▀",
        ""
    )

    foreach ($msg in $bootMessages) {
        [Console]::ForegroundColor = [ConsoleColor]::Magenta
        Write-Host $msg
        Start-Sleep -Milliseconds 180
    }

    Start-Sleep -Milliseconds 500
    Clear-Host
}

Show-BootSequence

$cols = $host.UI.RawUI.WindowSize.Width
$rows = $host.UI.RawUI.WindowSize.Height

# Matrix-ish glyphs with cyberpunk flair
$glyphs = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン@#$*+?/%<>!^&|~"
$glyphsLen = $glyphs.Length

# Column state
$head = New-Object int[] $cols
$length = New-Object int[] $cols
$speed = New-Object int[] $cols

for ($i = 0; $i -lt $cols; $i++) {
    $head[$i] = -1
    $length[$i] = 0
    $speed[$i] = Get-Random -Minimum 1 -Maximum 3
}

# Frame counter for scanlines
$frameCount = 0
$scanlineIntensity = 0

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
    } catch {
        # Position out of bounds, skip
    }
}

function DrawScanlines {
    # Flickering scanline effect
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 25) {
        $scanlineY = Get-Random -Minimum 0 -Maximum $rows
        $char = if ((Get-Random -Minimum 0 -Maximum 2) -eq 0) { "━" } else { "▬" }

        for ($x = 0; $x -lt $cols; $x += 2) {
            Set-Cell -x $x -y $scanlineY -char $char -color ([ConsoleColor]::DarkMagenta)
        }
    }
}

function DrawFrame {
    # Clear with black
    for ($y = 0; $y -lt $rows; $y++) {
        for ($x = 0; $x -lt $cols; $x++) {
            Set-Cell -x $x -y $y -char " " -color ([ConsoleColor]::Black)
        }
    }

    # Draw rain columns
    for ($x = 0; $x -lt $cols; $x++) {
        # Spawn new rain columns
        if ($head[$x] -lt 0) {
            if ((Get-Random -Minimum 0 -Maximum 100) -lt 10) {
                $head[$x] = 0
                $length[$x] = Get-Random -Minimum 10 -Maximum 35
                $speed[$x] = Get-Random -Minimum 1 -Maximum 3
            }
            continue
        }

        $top = $head[$x]
        $trailStart = $top - $length[$x]

        # Reset if off-screen
        if ($top -ge $rows) {
            $head[$x] = -1
            $length[$x] = 0
            continue
        }

        # Draw trail
        for ($y = $trailStart; $y -le $top; $y++) {
            if ($y -lt 0 -or $y -ge $rows) { continue }

            $dist = $top - $y
            $index = Get-Random -Minimum 0 -Maximum ($glyphsLen - 1)
            $char = $glyphs[$index]

            # Bright white head
            if ($dist -eq 0) {
                Set-Cell -x $x -y $y -char $char -color ([ConsoleColor]::White)
            }
            # Neon cyan glow
            elseif ($dist -lt 3) {
                Set-Cell -x $x -y $y -char $char -color ([ConsoleColor]::Cyan)
            }
            # Magenta mid-trail (cyberpunk accent!)
            elseif ($dist -lt 8) {
                Set-Cell -x $x -y $y -char $char -color ([ConsoleColor]::Magenta)
            }
            # Green fade-out
            else {
                Set-Cell -x $x -y $y -char $char -color ([ConsoleColor]::Green)
            }
        }

        $head[$x] += $speed[$x]
    }

    # Add flickering scanlines
    DrawScanlines

    # Occasional glitch lines
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 3) {
        $glitchY = Get-Random -Minimum 0 -Maximum $rows
        $glitchX = Get-Random -Minimum 0 -Maximum ($cols - 10)
        $glitchLen = Get-Random -Minimum 5 -Maximum 15

        for ($i = 0; $i -lt $glitchLen; $i++) {
            if ($glitchX + $i -lt $cols) {
                $char = $glyphs[(Get-Random -Minimum 0 -Maximum ($glyphsLen - 1))]
                Set-Cell -x ($glitchX + $i) -y $glitchY -char $char -color ([ConsoleColor]::Magenta)
            }
        }
    }

    $frameCount++
}

# ============================================================================
# MAIN LOOP
# ============================================================================
while ($true) {
    DrawFrame
    Start-Sleep -Milliseconds 50
}
