$Path = "D:\"
$MinSize = 1GB

$files = Get-ChildItem -Path $Path -File -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.Length -ge $MinSize }

$duplicates = $files |
    Group-Object { "$($_.Name.ToLowerInvariant())|$($_.Length)" } |
    Where-Object { $_.Count -gt 1 }

foreach ($group in $duplicates) {

    $size = $group.Group[0].Length
    $wasted = $size * ($group.Count - 1)

    Write-Host "`n========================================"
    Write-Host "File name : $($group.Group[0].Name)"
    Write-Host "Size      : $([math]::Round($size / 1GB, 2)) GB"
    Write-Host "Copies    : $($group.Count)"
    Write-Host "Can free  : $([math]::Round($wasted / 1GB, 2)) GB"

    foreach ($file in $group.Group) {
        Write-Host "  $($file.FullName)"
    }
}

$totalWasted = ($duplicates | ForEach-Object {
    $_.Group[0].Length * ($_.Count - 1)
} | Measure-Object -Sum).Sum

Write-Host "`n========================================"
Write-Host "TOTAL POTENTIAL SPACE TO FREE:"
Write-Host "$([math]::Round($totalWasted / 1GB, 2)) GB"
Write-Host "========================================"