# projector-enhanced.ps1
# Slow movie projector / film burn / laser-scratch terminal screensaver
# Enhanced: better brand treatment, improved contrast, refined timing
# Windows 11 Terminal compatible - NO shell path visible
# Press Ctrl+C to exit

$ErrorActionPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

$FrameDelayMs = 185
$esc = [char]27
$reset = "$esc[0m"
$home = "$esc[H"
$clear = "$esc[2J"
$hide = "$esc[?25l"
$show = "$esc[?25h"
$altOn = "$esc[?1049h"
$altOff = "$esc[?1049l"
$eraseScrollback = "$esc[3J"

$Color = @{
    White   = '38;2;250;248;230'
    Bone    = '38;2;222;216;190'
    Cyan    = '38;2;0;200;235'
    Magenta = '38;2;225;0;135'
    Amber   = '38;2;240;170;70'
    Red     = '38;2;210;65;50'
    Dim     = '38;2;84;84;100'
    Ghost   = '38;2;34;36;46'
    DarkCyn = '38;2;18;68;84'
    DarkMag = '38;2;70;12;64'
}

$Dust = @(' ', ' ', ' ', '.', '·', ':', '°')
$Burn = @('░','▒','▓','█','·',' ')
$LineChars = @('╱','╲','/','\','─','━','═','_','-')
$SideChars = @('▯','▮','▯',' ')

function A {
    param([string]$Code)
    return ($esc + '[' + $Code + 'm')
}

function Pick {
    param([array]$Items)
    return $Items[(Get-Random -Minimum 0 -Maximum $Items.Count)]
}

function New-Line {
    param([int]$Width)
    $chars = New-Object 'string[]' $Width
    $cols  = New-Object 'string[]' $Width
    for ($i = 0; $i -lt $Width; $i++) {
        $chars[$i] = ' '
        $cols[$i] = $Color.Ghost
    }
    return [pscustomobject]@{
        Chars = $chars
        Cols  = $cols
    }
}

function Set-Pixel {
    param($Line, [int]$X, [string]$Char, [string]$Code)
    if ($X -lt 0 -or $X -ge $Line.Chars.Count) { return }
    $Line.Chars[$X] = $Char
    $Line.Cols[$X] = $Code
}

function Write-Text {
    param($Line, [int]$X, [string]$Text, [string]$Code)
    for ($i = 0; $i -lt $Text.Length; $i++) {
        Set-Pixel -Line $Line -X ($X + $i) -Char $Text[$i] -Code $Code
    }
}

function Render-Line {
    param($Line)
    $sb = [System.Text.StringBuilder]::new()
    $active = ''
    for ($i = 0; $i -lt $Line.Chars.Count; $i++) {
        $c = $Line.Cols[$i]
        if ($c -ne $active) {
            [void]$sb.Append((A $c))
            $active = $c
        }
        [void]$sb.Append($Line.Chars[$i])
    }
    [void]$sb.Append($reset)
    return $sb.ToString()
}

function Draw-Sprockets {
    param($Line, [int]$Y, [int]$Frame, [int]$Width)
    $phase = ($Y + [int]($Frame / 2)) % 7
    if ($phase -lt 2) {
        Write-Text -Line $Line -X 1 -Text (Pick $SideChars) -Code (Pick @($Color.Dim,$Color.DarkCyn,$Color.Bone))
        Write-Text -Line $Line -X ($Width - 3) -Text (Pick $SideChars) -Code (Pick @($Color.Dim,$Color.DarkCyn,$Color.Bone))
    }
}

function Draw-BurnBloom {
    param($Line, [int]$Y, [int]$Frame, [int]$Width, [int]$Height)
    $cx = [int](($Width * 0.68) + ([Math]::Sin($Frame / 54.0) * ($Width * 0.18)))
    $cy = [int](($Height * 0.42) + ([Math]::Cos($Frame / 61.0) * ($Height * 0.22)))
    $r = 4 + [int]([Math]::Abs([Math]::Sin($Frame / 44.0)) * 10)
    
    $dy = [Math]::Abs($Y - $cy)
    if ($dy -gt $r) { return }
    
    $span = [int]([Math]::Sqrt(($r * $r) - ($dy * $dy)) * 1.8)
    for ($x = ($cx - $span); $x -le ($cx + $span); $x++) {
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 54) {
            $dist = [Math]::Abs($x - $cx) + $dy
            $code = if ($dist -lt 4) { $Color.White } elseif ($dist -lt 9) { $Color.Amber } else { Pick @($Color.DarkMag,$Color.Magenta,$Color.Red,$Color.Dim) }
            Set-Pixel -Line $Line -X $x -Char (Pick $Burn) -Code $code
        }
    }
}

function Draw-LaserScratches {
    param($Line, [int]$Y, [int]$Frame, [int]$Width, [int]$Height)
    for ($n = 0; $n -lt 5; $n++) {
        $base = [int](($Width * (($n + 1) / 6.0)) + ([Math]::Sin(($Frame + ($n * 77)) / 70.0) * 18))
        $x = [int]($base + (($Y - ($Height / 2)) * (0.16 * (($n % 2) * 2 - 1))))
        
        if ((($Y + $Frame + ($n * 11)) % 4) -ne 0) {
            Set-Pixel -Line $Line -X $x -Char (Pick $LineChars) -Code (Pick @($Color.Cyan,$Color.Magenta,$Color.White,$Color.DarkCyn,$Color.Dim))
        }
    }
}

function Draw-Dust {
    param($Line, [int]$Width)
    for ($i = 0; $i -lt [int]($Width * 0.05); $i++) {
        $x = Get-Random -Minimum 0 -Maximum $Width
        Set-Pixel -Line $Line -X $x -Char (Pick $Dust) -Code (Pick @($Color.Ghost,$Color.Dim,$Color.DarkCyn,$Color.DarkMag,$Color.Bone))
    }
}

function Draw-Signature {
    param($Line, [int]$Y, [int]$Width, [int]$Height)
    
    # BURNSID signature with enhanced visibility
    if ((Get-Random -Minimum 0 -Maximum 100) -lt 58) {
        $sig = 'B U R N S I D //'
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 18) {
            $sig = 'B U R N   S I D //'
        }
        
        $row = [Math]::Max(2, $Height - 5)
        if ($Y -ne $row) { return }
        
        $x = [Math]::Max(2, [int]($Width * 0.06))
        Write-Text -Line $Line -X $x -Text $sig -Code (Pick @($Color.Bone,$Color.Cyan,$Color.Magenta,$Color.Amber))
        
        # Secondary tag line
        if ((Get-Random -Minimum 0 -Maximum 100) -lt 35) {
            $tag = 'FIELD // KIT'
            $tagX = [Math]::Max(2, $x + $sig.Length + 8)
            if ($tagX + $tag.Length -lt $Width - 2) {
                Write-Text -Line $Line -X $tagX -Text $tag -Code (Pick @($Color.DarkCyn,$Color.Dim,$Color.Cyan))
            }
        }
    }
}

try {
    try { $host.UI.RawUI.WindowTitle = 'PROJECTOR BURN // BURNSID // FIELD KIT' } catch {}
    try { [Console]::CursorVisible = $false } catch {}
    
    # Alternate screen buffer - no shell path visible
    [Console]::Write($altOn + $hide + $clear + $eraseScrollback)
    
    $frame = 0

    while ($true) {
        $width = [Math]::Max(64, [Console]::WindowWidth)
        $height = [Math]::Max(22, [Console]::WindowHeight)

        $sb = [System.Text.StringBuilder]::new()
        [void]$sb.Append($home)

        for ($y = 0; $y -lt $height; $y++) {
            $line = New-Line -Width $width

            Draw-Sprockets -Line $line -Y $y -Frame $frame -Width $width
            Draw-Dust -Line $line -Width $width
            Draw-BurnBloom -Line $line -Y $y -Frame $frame -Width $width -Height $height
            Draw-LaserScratches -Line $line -Y $y -Frame $frame -Width $width -Height $height
            Draw-Signature -Line $line -Y $y -Width $width -Height $height

            [void]$sb.Append((Render-Line -Line $line))
            if ($y -lt ($height - 1)) {
                [void]$sb.Append("`n")
            }
        }

        [Console]::Write($sb.ToString())
        $frame++
        Start-Sleep -Milliseconds $FrameDelayMs
    }
}
finally {
    [Console]::Write($reset + $show + $altOff)
    try { [Console]::CursorVisible = $true } catch {}
}
