# cyber-rain-ultimate.ps1
# ULTIMATE CYBERPUNK MATRIX RAIN
# Features:
# - Cinematic boot sequence with heavy rain overlay fighting boot text
# - BURNSID // & FIELD // KIT branding with randomized flicker
# - 24-hour clock display
# - Synthwave/cyberpunk broken terminal aesthetic
# - Uses alternate screen buffer (no shell path bleeding)
# - Retro Terminal Effects compatible for Windows 11 Terminal
# Press Ctrl+C to stop

$ErrorActionPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

# --- TUNING ------------------------------------------------------------------
$FrameDelayMs       = 45      # boot phase timing
$DropDensity        = 65      # rain density after boot
$SpawnChance        = 8       # column respawn chance
$BackgroundNoise    = 5       # per-cell noise out of 1000
$ScanlineChance     = 9       # per-frame scanline chance
$GlitchChance       = 6       # per-frame glitch burst
$BrandingChance     = 82      # signature visibility after intro
$BootFrames         = 200     # frames for boot sequence

# --- ANSI (TRUECOLOR) --------------------------------------------------------
$esc   = [char]27
$reset = "$esc[0m"
$hide  = "$esc[?25l"
$show  = "$esc[?25h"
$clear = "$esc[2J"
$home  = "$esc[H"
$altOn = "$esc[?1049h"
$altOff = "$esc[?1049l"
$eraseScrollback = "$esc[3J"

$colors = @{
    Hot     = '38;2;255;0;180'      # neon magenta
    Pink    = '38;2;255;80;210'     # bright pink
    Cyan    = '38;2;0;245;255'      # neon cyan
    Blue    = '38;2;70;150;255'     # cobalt blue
    Green   = '38;2;80;255;120'     # lime green
    Lime    = '38;2;170;255;80'     # neon lime
    White   = '38;2;245;245;255'    # bright white
    Bone    = '38;2;220;215;195'    # off-white
    Dim     = '38;2;100;100;125'    # dim gray
    Ghost   = '38;2;45;48;58'       # very dark bg
    DarkMag = '38;2;90;20;85'       # dark magenta
    DarkCyn = '38;2;20;75;95'       # dark cyan
    DarkGrn = '38;2;25;85;40'       # dark green
}

$glyphs = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#$%&@<>/\+-=*[]{}░▒▓'.ToCharArray()
$staticGlyphs = '.·:¦|_-=░▒'.ToCharArray()
$scanChars = @('─','━','═','▔','▁','░','▒',' ')

function A {
    param([string]$Code)
    return ($esc + '[' + $Code + 'm')
}

function MoveTo {
    param([int]$Row,[int]$Col)
    return ($esc + '[' + $Row + ';' + $Col + 'H')
}

function PickGlyph {
    return $glyphs[(Get-Random -Minimum 0 -Maximum $glyphs.Count)]
}

function PickStatic {
    return $staticGlyphs[(Get-Random -Minimum 0 -Maximum $staticGlyphs.Count)]
}

function PickFrom {
    param([array]$Items)
    return $Items[(Get-Random -Minimum 0 -Maximum $Items.Count)]
}

function CenterX {
    param([string]$Text,[int]$Width)
    return [Math]::Max(1, [int](($Width - $Text.Length) / 2))
}

function Get-ClockText {
    return (Get-Date).ToString('HH:mm:ss')
}

function WriteAt {
    param(
        [System.Text.StringBuilder]$Sb,
        [int]$Row,
        [int]$Col,
        [string]$Text,
        [string]$ColorCode
    )
    [void]$Sb.Append((MoveTo -Row $Row -Col $Col))
    [void]$Sb.Append((A $ColorCode))
    [void]$Sb.Append($Text)
    [void]$Sb.Append($reset)
}

function New-Trail {
    param([int]$Length)
    $trail = New-Object 'char[]' $Length
    for ($i = 0; $i -lt $Length; $i++) {
        $trail[$i] = PickGlyph
    }
    return $trail
}

function New-Drop {
    param([int]$X,[int]$Height)
    $len = Get-Random -Minimum 14 -Maximum ([Math]::Max(16,[Math]::Min(38,$Height)))
    $step = Get-Random -Minimum 1 -Maximum 5
    
    [pscustomobject]@{
        X         = $X
        Head      = Get-Random -Minimum (-$Height) -Maximum $Height
        Len       = $len
        Style     = @('cyan','pink','green','mixed')[(Get-Random -Minimum 0 -Maximum 4)]
        Active    = ((Get-Random -Minimum 0 -Maximum 100) -lt $DropDensity)
        Tick      = Get-Random -Minimum 0 -Maximum $step
        StepEvery = $step
        Cool      = Get-Random -Minimum 15 -Maximum 80
        Trail     = New-Trail -Length $len
    }
}

function Reset-Drop {
    param($Drop,[int]$Height)
    $len = Get-Random -Minimum 14 -Maximum ([Math]::Max(16,[Math]::Min(38,$Height)))
    $step = Get-Random -Minimum 1 -Maximum 5
    
    $Drop.Head      = Get-Random -Minimum (-$Height) -Maximum 0
    $Drop.Len       = $len
    $Drop.Style     = @('cyan','pink','green','mixed')[(Get-Random -Minimum 0 -Maximum 4)]
    $Drop.Active    = $true
    $Drop.Tick      = Get-Random -Minimum 0 -Maximum $step
    $Drop.StepEvery = $step
    $Drop.Cool      = Get-Random -Minimum 15 -Maximum 80
    $Drop.Trail     = New-Trail -Length $len
}

function New-Drops {
    param([int]$Width,[int]$Height)
    $drops = @()
    for ($x = 0; $x -lt $Width; $x++) {
        if ((Get-Random -Minimum 0 -Maximum 100) -lt $DropDensity) {
            $drops += (New-Drop -X $x -Height $Height)
        }
    }
    return $drops
}

function Get-DropColor {
    param([string]$Style,[int]$Dist)
    if ($Dist -eq 0) { return $colors.White }
    
    switch ($Style) {
        'pink' {
            if ($Dist -lt 3) { return $colors.Pink }
            if ($Dist -lt 9) { return $colors.Hot }
            return $colors.DarkMag
        }
        'cyan' {
            if ($Dist -lt 3) { return $colors.Cyan }
            if ($Dist -lt 9) { return $colors.Blue }
            return $colors.DarkCyn
        }
        'green' {
            if ($Dist -lt 3) { return $colors.Lime }
            if ($Dist -lt 9) { return $colors.Green }
            return $colors.DarkGrn
        }
        'mixed' {
            if ($Dist -lt 3) { return PickFrom @($colors.Pink,$colors.Cyan,$colors.Lime,$colors.Bone) }
            if ($Dist -lt 9) { return PickFrom @($colors.Hot,$colors.Blue,$colors.Green) }
            return PickFrom @($colors.DarkMag,$colors.DarkCyn,$colors.DarkGrn)
        }
        default {
            if ($Dist -lt 3) { return $colors.Green }
            if ($Dist -lt 9) { return $colors.Green }
            return $colors.DarkGrn
        }
    }
}

function Advance-Drops {
    param([array]$Drops,[int]$Height)
    
    foreach ($d in $Drops) {
        if (-not $d.Active) {
            if ($d.Cool -gt 0) {
                $d.Cool--
            }
            elseif ((Get-Random -Minimum 0 -Maximum 100) -lt $SpawnChance) {
                Reset-Drop -Drop $d -Height $Height
            }
            continue
        }
        
        $d.Tick++
        if (($d.Tick % $d.StepEvery) -eq 0) {
            $d.Head += 1
            
            # Glyph life - mostly persistent, slow drift
            if ((Get-Random -Minimum 0 -Maximum 100) -lt 18) {
                $idx = Get-Random -Minimum 0 -Maximum $d.Trail.Count
                $d.Trail[$idx] = PickGlyph
            }
            if ((Get-Random -Minimum 0 -Maximum 100) -lt 38) {
                $d.Trail[0] = PickGlyph
            }
        }
        
        if (($d.Head - $d.Len) -gt $Height) {
            $d.Active = $false
            $d.Cool = Get-Random -Minimum 20 -Maximum 100
            $d.Head = Get-Random -Minimum (-$Height) -Maximum 0
        }
    }
}

# --- BOOT SEQUENCE -----------------------------------------------------------
function Boot-Cinematic {
    param([int]$Width, [int]$Height)
    
    $bootLines = @(
        "╔════════════════════════════════════════════════════╗",
        "║                                                    ║",
        "║      ▄▀  ▀▄    █▀▀▀█   ▀▀█▀▀   █▀▀▀  █▀▀▀█      ║",
        "║      █    █    █       █      █      █           ║",
        "║      █    █    █▀▀▀    █      █▀▀▀  █▀▀▀█       ║",
        "║      █    █    █       █      █      █           ║",
        "║      ▀▀  ▀▀    █       █      █▀▀▀  █           ║",
        "║                                                    ║",
        "║           NEURAL MATRIX INITIALIZED              ║",
        "║        [FIELD // KIT // SECURE CHANNEL]          ║",
        "║                                                    ║",
        "╚════════════════════════════════════════════════════╝"
    )
    
    $sysMessages = @(
        "[INIT] Loading neural pathways...",
        "[SYNC] Cyan frequency locked...",
        "[SYNC] Magenta cascade primed...",
        "[SYNC] Green decay layer active...",
        "[BOOT] Rain engine: INITIALIZING",
        "[BOOT] Scanline system: ONLINE",
        "[BOOT] Terminal mode: ENGAGED",
        "[BOOT] Flicker effect: READY",
        "[READY] CYBERSPACE INITIALIZED"
    )
    
    $sb = [System.Text.StringBuilder]::new()
    
    # Boot phase with heavy rain overlay fighting boot text
    for ($frame = 0; $frame -lt $BootFrames; $frame++) {
        [void]$sb.Append($clear)
        [void]$sb.Append($home)
        
        # Boot text phases
        $bootIdx = [Math]::Floor($frame / 20)
        if ($bootIdx -ge 0 -and $bootIdx -lt $bootLines.Length) {
            $bootY = [Math]::Floor($Height / 2) - ([Math]::Floor($bootLines.Length / 2)) + $bootIdx
            if ($bootY -ge 0 -and $bootY -le $Height) {
                $bootColor = PickFrom @($colors.Hot,$colors.Cyan,$colors.Green,$colors.Pink)
                WriteAt -Sb $sb -Row $bootY -Col 1 -Text $bootLines[$bootIdx] -ColorCode $bootColor
            }
        }
        
        # System message
        $msgIdx = [Math]::Floor($frame / 22)
        if ($msgIdx -ge 0 -and $msgIdx -lt $sysMessages.Length) {
            $msg = $sysMessages[$msgIdx]
            $msgY = $Height - 4
            $msgColor = PickFrom @($colors.Cyan,$colors.Green,$colors.Lime)
            WriteAt -Sb $sb -Row $msgY -Col 2 -Text $msg -ColorCode $msgColor
        }
        
        # HEAVY RAIN OVERLAY - fighting with boot text
        $dropByX = New-Object 'object[]' $Width
        for ($x = 0; $x -lt $Width; $x++) {
            if ((Get-Random -Minimum 0 -Maximum 100) -lt 48) {
                $rainLen = Get-Random -Minimum 4 -Maximum 14
                $rainY = Get-Random -Minimum 3 -Maximum ($Height - 6)
                
                for ($i = 0; $i -lt $rainLen; $i++) {
                    $y = $rainY + $i
                    if ($y -ge 0 -and $y -le $Height) {
                        $ch = PickGlyph
                        $rainColor = PickFrom @($colors.Cyan,$colors.Hot,$colors.Green,$colors.Blue,$colors.DarkCyn)
                        WriteAt -Sb $sb -Row $y -Col $x -Text $ch -ColorCode $rainColor
                    }
                }
            }
        }
        
        # Scanline flicker during boot
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 32) {
            $scanY = Get-Random -Minimum 2 -Maximum ($Height - 3)
            $scan = ''
            for ($i = 0; $i -lt [Math]::Min(30, $Width); $i++) {
                $scan += PickFrom $scanChars
            }
            WriteAt -Sb $sb -Row $scanY -Col 1 -Text $scan -ColorCode $colors.DarkMag
        }
        
        [Console]::Write($sb.ToString())
        $sb.Clear() | Out-Null
        Start-Sleep -Milliseconds $FrameDelayMs
    }
    
    Write-Host ''
}

# --- MAIN RAIN LOOP ----------------------------------------------------------
function Draw-Frame {
    param(
        [array]$Drops,
        [int]$Frame,
        [int]$Width,
        [int]$Height
    )
    
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.Append($clear)
    [void]$sb.Append($home)
    
    $dropByX = New-Object 'object[]' $Width
    foreach ($d in $Drops) {
        if ($d.Active -and $d.X -ge 0 -and $d.X -lt $Width) {
            $dropByX[$d.X] = $d
        }
    }
    
    for ($y = 0; $y -lt $Height; $y++) {
        for ($x = 0; $x -lt $Width; $x++) {
            $printed = $false
            $d = $dropByX[$x]
            
            if ($null -ne $d) {
                $dist = $d.Head - $y
                if ($dist -ge 0 -and $dist -lt $d.Len) {
                    $glyph = if ($dist -lt $d.Trail.Count) { $d.Trail[$dist] } else { PickGlyph }
                    [void]$sb.Append((A (Get-DropColor -Style $d.Style -Dist $dist)))
                    [void]$sb.Append($glyph)
                    [void]$sb.Append($reset)
                    $printed = $true
                }
            }
            
            if (-not $printed) {
                if ((Get-Random -Minimum 0 -Maximum 1000) -lt $BackgroundNoise) {
                    [void]$sb.Append((A (PickFrom @($colors.Ghost,$colors.Dim,$colors.DarkCyn,$colors.DarkMag,$colors.DarkGrn))))
                    [void]$sb.Append((PickStatic))
                    [void]$sb.Append($reset)
                }
                else {
                    [void]$sb.Append(' ')
                }
            }
        }
        if ($y -lt ($Height - 1)) { [void]$sb.Append("`n") }
    }
    
    # Branding overlay - randomized flicker
    if ((Get-Random -Minimum 0 -Maximum 100) -lt $BrandingChance) {
        $phase = [int]($Frame / 18)
        
        # BURNSID signature
        $sig1 = 'B U R N S I D //'
        if (($phase % 7) -eq 0) {
            $sig1 = 'B U R N   S I D //'
        }
        
        # FIELD // KIT tag
        $sig2 = 'F I E L D  //  K I T'
        
        $clock = Get-ClockText
        
        $row1 = [Math]::Max(2, $Height - 5)
        $row2 = [Math]::Max(3, $Height - 3)
        $col = [Math]::Max(2, [int]($Width * 0.06))
        
        # Slower flicker: mostly visible
        if (($Frame % 38) -notin @(0,1,2,3)) {
            $c1 = PickFrom @($colors.Cyan,$colors.Hot,$colors.Pink,$colors.Bone)
            WriteAt -Sb $sb -Row $row1 -Col $col -Text $sig1 -ColorCode $c1
        }
        
        if (($Frame % 45) -notin @(0,1,2,3,4)) {
            $c2 = PickFrom @($colors.Cyan,$colors.Hot,$colors.Lime,$colors.Bone)
            WriteAt -Sb $sb -Row $row2 -Col $col -Text $sig2 -ColorCode $c2
        }
        
        # 24h clock on same line as BURNSID
        if (($Frame % 52) -notin @(0,1,2,3,4,5)) {
            $clockCol = $col + $sig1.Length + 6
            if ($clockCol -lt ($Width - $clock.Length - 2)) {
                $cc = PickFrom @($colors.Cyan,$colors.Bone,$colors.Green,$colors.Dim)
                WriteAt -Sb $sb -Row $row1 -Col $clockCol -Text $clock -ColorCode $cc
            }
        }
    }
    
    # Scanlines
    if ((Get-Random -Minimum 0 -Maximum 100) -lt $ScanlineChance) {
        $scanY = Get-Random -Minimum 2 -Maximum ([Math]::Max(3,$Height - 2))
        $start = Get-Random -Minimum 1 -Maximum ([Math]::Max(2,[int]($Width * 0.40)))
        $len = Get-Random -Minimum 10 -Maximum ([Math]::Max(11,[int]($Width * 0.50)))
        $scan = ''
        for ($i = 0; $i -lt $len; $i++) {
            $scan += PickFrom $scanChars
        }
        $sc = PickFrom @($colors.DarkMag,$colors.DarkCyn,$colors.Dim)
        WriteAt -Sb $sb -Row $scanY -Col $start -Text $scan -ColorCode $sc
    }
    
    # Glitch bursts
    if ((Get-Random -Minimum 0 -Maximum 100) -lt $GlitchChance) {
        $gx = Get-Random -Minimum 1 -Maximum ([Math]::Max(2,$Width - 14))
        $gy = Get-Random -Minimum 2 -Maximum ([Math]::Max(3,$Height - 2))
        $glen = Get-Random -Minimum 6 -Maximum 15
        $glitch = ''
        for ($i = 0; $i -lt $glen; $i++) {
            $glitch += PickGlyph
        }
        $gc = PickFrom @($colors.Hot,$colors.Cyan,$colors.Pink)
        WriteAt -Sb $sb -Row $gy -Col $gx -Text $glitch -ColorCode $gc
    }
    
    [Console]::Write($sb.ToString())
}

# --- MAIN EXECUTION ----------------------------------------------------------
try {
    $host.UI.RawUI.WindowTitle = 'BURNSID // FIELD // KIT // CYBERSPACE'
    try { [Console]::CursorVisible = $false } catch {}
    
    # Alternate screen buffer hides shell prompt
    [Console]::Write($altOn + $hide + $clear + $eraseScrollback)
    
    $width = [Math]::Max(60, [Console]::WindowWidth)
    $height = [Math]::Max(22, [Console]::WindowHeight)
    
    # Boot sequence
    Boot-Cinematic -Width $width -Height $height
    
    Start-Sleep -Milliseconds 300
    
    # Pure rain cascade
    $drops = New-Drops -Width $width -Height $height
    $frame = 0
    
    while ($true) {
        $newWidth = [Math]::Max(60, [Console]::WindowWidth)
        $newHeight = [Math]::Max(22, [Console]::WindowHeight)
        
        if ($newWidth -ne $width -or $newHeight -ne $height) {
            $width = $newWidth
            $height = $newHeight
            $drops = New-Drops -Width $width -Height $height
            [Console]::Write($clear + $home)
        }
        
        Advance-Drops -Drops $drops -Height $height
        Draw-Frame -Drops $drops -Frame $frame -Width $width -Height $height
        
        $frame++
        Start-Sleep -Milliseconds 38
    }
}
finally {
    [Console]::Write($reset + $show + $altOff)
    try { [Console]::CursorVisible = $true } catch {}
}
