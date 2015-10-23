

$url = "https://rsuionline.rsui.com/ba/_vti_bin/owssvr.dll?Cmd=Display&List={C6C5D471-324E-4A89-BA71-FF2F7F86C017}&View={EB9A9B24-253E-4A99-BFA4-6156665A7195}&XMLDATA=TRUE"
$xml = Invoke-WebRequest $url
$cred = Get-Credential
$xml = Invoke-WebRequest $url -Credential $cred
$x = [xml] $xml

x.xml.data.row | ForEach-Object {if ($_.ows_ISO_x0020_Notes -like '*http://www.rsui.com/forms*') { @{'Class'=$_.ows_Rating_x0020_Class_x0020_Number;'Title'=$_ows_Title}}}

$x.xml.data.row | ForEach-Object {if ($_.ows_ISO_x0020_Notes -like '*http://www.rsui.com/forms*') {$_.ows_ISO_x0020_Notes}} | Measure-Object