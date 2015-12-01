$b=(select-string .\version.txt -pattern '(\d\.)+')
$versionfromfile=$b.Line
Write-Host "versionfromfile" $versionfromfile
$regex="(\d+)\.(\d+)(\.(\d+))?"
$counter=20
$vers = $versionfromfile

$major=[regex]::match($vers ,$regex).Groups[1].Value
$minor=[regex]::match($vers ,$regex).Groups[2].Value
$minor=$(if ([string]::IsNullOrEmpty($minor)) { 0 } else { $minor })
$rev=[regex]::match($vers ,$regex).Groups[4].Value
$rev=$(if ([string]::IsNullOrEmpty($rev)) { 0 } else { $rev })

Write-Host 'Major:'$major 'Minor:'$minor 'Rev:'$rev
Write-Host "##teamcity[setParameter name='system.MajorVersion' value='$major']"
Write-Host "##teamcity[setParameter name='system.AssemblyVersion' value='$major.$minor.$rev.$counter']"
Write-Host "##teamcity[buildNumber '$major.$minor.$rev.$counter']"

$fullver = "$major.$minor.$rev.$counter"

function Update-AssemblyInfoFiles ($filelist, $vers) {
    $assemblyVersionPattern = 'AssemblyVersion\(".*"\)'
    $fileVersionPattern = 'AssemblyFileVersion\(".*"\)'
    $assemblyVersion = 'AssemblyVersion("' + $vers + '")';
    $fileVersion = 'AssemblyFileVersion("' + $vers + '")';
        
    for ($i = 0; $i -lt $filelist.Count; $i++)
	{
		"Updating versions in " + $filelist[$i].FullName +  " to " + $vers + "."
		
		(Get-Content $filelist[$i].FullName) | ForEach-Object {
        % {$_ -replace $assemblyVersionPattern, $assemblyVersion } |
        % {$_ -replace $fileVersionPattern, $fileVersion }
    	} | Set-Content $filelist[$i].FullName
	}     
}

# update solution info files 
$includes="SolutionInfo.cs","AssemblyInfo.cs"
$excludePattern="*\externals\*"
$sol_files=@(Get-ChildItem -r -include $includes | ? {$_.Fullname -inotlike $excludePattern})
Update-AssemblyInfoFiles $sol_files $fullver