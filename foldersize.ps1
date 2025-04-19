# folder-sizes-launcher.ps1
$CurrentDir = Get-Location
function Format-Size($bytes) {
    if (-not $bytes) {
        return "Empty"
    }
    if ($bytes -ge 1GB) {
        return "{0:N2} GB" -f ($bytes / 1GB)
    } elseif ($bytes -ge 1MB) {
        return "{0:N2} MB" -f ($bytes / 1MB)
    } elseif ($bytes -ge 1KB) {
        return "{0:N2} KB" -f ($bytes / 1KB)
    } else {
        return "$bytes B"
    }
}
Get-ChildItem -Path $CurrentDir -Directory | ForEach-Object {
    $folder = $_
    $size = (Get-ChildItem -Recurse -Force -ErrorAction SilentlyContinue -Path $folder.FullName | Measure-Object -Property Length -Sum).Sum
    $formattedSize = Format-Size $size

    $color = if ($size -gt 10GB) {
        'Red'
    } elseif ($size -gt 1GB) {
        'Yellow'
    } elseif ($size -gt 100MB) {
        'Cyan'
    } else {
        'Green'
    }

    Write-Host ("{0,-30} {1,15}" -f $folder.Name, $formattedSize) -ForegroundColor $color
}
