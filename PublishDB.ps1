# add path for SQLPackage.exe
#IF (-not ($env:Path).Contains( "C:\program files\microsoft sql server\130\DAC\bin"))
#{ $env:path = $env:path + ";C:\program files\microsoft sql server\130\DAC\bin;" }

#sqlpackage /a:extract /of:true /scs:"server=192.168.17.3;database=FedcapStaticData;trusted_connection=true" /tf:"C:\FedCapSys_Tools\FedcapDBCompare\FedcapDBCompare\bin\Debug\FedcapDBCompare.dacpac";

#sqlpackage.exe /a:deployreport /sf:"C:\TFSAgent\_work\2\s\FedcapDBCompare\bin\Debug\FedcapDBCompare.dacpac" /tcs:"server=192.168.17.3;database=FedcapStaticData;trusted_connection=true"

#sqlpackage.exe /a:script /op:"c:\test\change.sql" /of:True /sf:"C:\test\db_source.dacpac" /tcs:"server=.\sql2016; database=db_target;trusted_connection=True"

#[xml]$x = gc -Path "c:\test\report.xml";
#$x.DeploymentReport.Operations.Operation |
#% -Begin {$a=@();} -process {$name = $_.name; $_.Item | %  {$r = New-Object PSObject -Property @{Operation=$name; Value = $_.Value; Type = $_.Type} ; $a += $r;} }  -End {$a}



& "C:\program files\microsoft sql server\130\DAC\bin\SqlPackage.exe" /a:publish /tcs:"Data Source=fedcapsqlserver.database.windows.net;Initial Catalog=FedcapStaticData;User ID=rmorkas;Password=r@ny2100" /sf:"C:\TFSAgent\_work\2\s\FedcapDBCompare\bin\Debug\FedcapDBCompare.dacpac" /p:RegisterDataTierApplication=true /p:BlockWhenDriftDetected=false