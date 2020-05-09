$csgoPath = "C:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\csgo"

if (!(Test-Path $csgoPath)){
    throw "CSGO is not installed at the standard path"
}

if (-Not (Test-Path .\temp\))
{
     md -path .\temp\
}

Copy-Item .\csgo\* .\temp\ -Force -Recurse

[System.Collections.Generic.Dictionary[String, String]]$dictionary = New-Object -TypeName "System.Collections.Generic.Dictionary[String, String]"

foreach ($line in [System.IO.File]::ReadLines(".\usercfg.cfg"))
{
    [String]$line = $line
    if ($line.Contains("//")){
        continue
    }

    if (!$line.Contains("=")){
        continue
    }

    $split = $line.Split('=')

    [String]$split1 = $split[0]
    [String]$split2 = $split[1]

    $dictionary.Add($split1, $split2)

    $string = "Substituting @@" + $split1 + "@@ with " + $split2
    
    Write-Host $string
}


foreach ($file in Get-ChildItem ".\temp\cfg\cfg\")
{
    foreach ($keyvaluepair in $dictionary.GetEnumerator()){
    [System.Collections.Generic.KeyValuePair[string,string]]$keyvaluepair = $keyvaluepair

    (Get-Content $file.FullName).replace("@@" + $keyvaluepair.Key + "@@", $keyvaluepair.Value) | Set-Content $file.FullName
    }
}


Copy-Item .\temp\* $csgoPath -Force -Recurse

Remove-Item -Path .\temp\ -Recurse -Force

Write-Host "Installation succeeded"