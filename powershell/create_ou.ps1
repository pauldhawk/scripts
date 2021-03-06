function Open-Csv{
	$fileName = ".\a.csv"
		
	Import-CSV $fileName | ForEach-Object { 
			Create-Group  -name $_.Company -client "citi" -subfolder "Venders"
	}	
}

function ADObject-Exits {
		param(
		[Parameter(Mandatory=$True,Position=1)]
		$name )
		$obj = "LDAP://{0}" -f $name
		return [adsi]::Exists($obj)
} 

Function Create-Ou {
	param(
		[string]$fullpath,
		[string]$path,
		[string]$name
	)
	if (-not(ADObject-Exits $fullpath)) {
		New-ADOrganizationalUnit -name $name -path $path 
	}
}



Function Create-Group{
	param(
		[Parameter(Mandatory=$True,Position=1)]
		[string]$name,
		[Parameter(Mandatory=$True)]
		[string]$client,
		[string]$subFolder)
	
	$ad = Get-ADDomain | ForEach {  $_.DistinguishedName } 
		
	### group ou paths ###
	
	# OU=citi,OU=Clients,DC=havaschicago,DC=com
	$gOu = "OU=Groups,{0}" -f $ad

	$gOu1 = "OU={0},OU=Groups,{1}" -f $client, $ad
	Create-Ou -fullpath $gOu1 -path $gOu -name $client
	$mGOu = $gOu1
	
	# add subgroup if subfolder ie OU=Venders,OU=citi,OU=Groups, DC=havaschicago,DC=com
	if ($subFolder) { 
		$gOu2 = "OU={0}, OU={1},OU=Groups,{2}" -f $subFolder, $client, $ad
		Create-Ou -fullpath $gOu2 -path $gOu1 -name $subFolder
		$mGOu =$gOu2
	}
	
	
	### users ou paths ###
	
	# go to client folder OU=citi,OU=Clients,DC=havaschicago,DC=com
	$cOu = "OU=Clients,{0}" -f $ad
	$cOu1 = "OU={0},OU=Clients,{1}" -f $client, $ad
	Create-Ou -fullpath $cOu1 -path $cOu -name $client
	
	if ($subFolder) { 
		$cOu2 = "OU={0},OU={1},OU=Clients,{2}" -f $subFolder, $client, $ad
		Create-Ou -fullpath $cOu2 -path $cOu1 -name $subFolder
		$cOu3 = "OU={0}, OU={1}, OU={2},OU=Clients,{3}" -f $name, $subFolder, $client, $ad
		Create-Ou -fullpath $cOu3 -path $cOu2 -name $name
	}
	else { 
		$cOu2 = "OU={0},OU={1},OU=Clients,{2}" -f $name, $client, $ad
		Create-Ou -fullpath $cOu2 -path $cOu1 -name $name
	}
	
	### Create the groups ###

	$groupPath = "CN={0},{1}" -f $name, $mGOu
	if (-not(ADObject-Exits $groupPath)){
		New-ADGroup -Name $name -GroupScope 0 -path $mGOu
	}
}
Open-Csv



#need to lower and trim all data
