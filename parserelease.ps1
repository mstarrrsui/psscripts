##parse release tag
$InputStr=$args[0]

$regex='(release-)(\d)\.(\d)\.(\d)'

$major=[regex]::match($InputStr,$regex).Groups[2].Value
$minor=[regex]::match($InputStr,$regex).Groups[3].Value
$rev=[regex]::match($InputStr,$regex).Groups[4].Value

Write-Host 'Major:'$major 'Minor:'$minor 'Rev:'$rev
