$source = "E:\Docker\PopSystem\SOW\08_Dev_Planning"
$dest = "$source\99_Archive\Legacy_Mixed_Stack"
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$items = Get-ChildItem -Path $source -Exclude "00_Meta", "99_Archive"
foreach ($item in $items) {
    Move-Item -Path $item.FullName -Destination $dest -Force
    Write-Host "Archived: $($item.Name)"
}
