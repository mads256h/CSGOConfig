$csgoPath = "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo"

if (!(Test-Path $csgoPath)){
    throw "CSGO is not installed at the standard path"
}

Copy-Item .\csgo\* $csgoPath -Force -Recurse

Write-Host "Installation succeeded"