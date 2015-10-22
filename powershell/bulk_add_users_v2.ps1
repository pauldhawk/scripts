# v 2

### steps to new user
# 1. need a ou to put the new user
#	a. check to see if one exists
# 	b. if not create one and return
# 	c. if one does exits just return it
#
# 2. create user / chagnge password
#	a. user extis return it
# 	b. if user does not exist craete and return
#
# 3. get or set group
#	if group exits return it
# 	if not create group
#		- check location
#		- create
# 		-retrun
#
#	4. add user to group



Import-Module ActiveDirectory


function Get-cvsData {
	$fullpath = ".\abc.csv"

	$uCsv = Import-CSV $fullpath
	$uCsv | ForEach-Object {
		# get extra data need for user
		Get-ExtraData -usr $_
		# check to see if ou paths are created and return
		GetOrSet-Ou -usr $_
		# check for user in the sytem and return it
		$thisUser = GetOrSet-User -usr $_
		# check for group retrun it
		$thisGroup = GetOrSet-Group -usr $_
		Add-ADGroupMember $thisGroup -Member $thisUser -whatif -ErrorAction SilentlyContinue
	}
}

# Helper Functions ########################
# Extra Data Needed to craete all objects
Function Get-ExtraData{
	param($usr)
	$usr.sam = Get-Sam $usr.GivenName $usr.SN
	$usr.name = ("{0} {1}" -f ($usr.GivenName,$usr.SN))
	$usr.DisplayName = ("{0}, {1}" -f ($usr.SN, $usr.GivenName))
}

#check for object
function ADObject-Exits {
		param(
		[Parameter(Mandatory=$True,Position=1)]
		$name )
		$obj = "LDAP://{0}" -f $name
		return [adsi]::Exists($obj)
}
# used with get-extradata to get sam
Function Get-Sam([string]$fn,[string]$ln){
	$fn = $fn.tolower().trim()
	$ln = $ln.tolower().trim()
	$sam = ("{0}{1}" -f $fn[0],$ln)
	return $sam
}


# Ou Functions ######################################

function GetOrSet-Ou {
	Param($usr)
	$ad = Get-ADDomain | ForEach {  $_.DistinguishedName }
	$gOu = "OU=Groups,{0}" -f $ad
	$gOu1 = "OU={0},OU=Groups,{1}" -f $usr.client, $ad

	# create the ou if not present
	if (-not (ADObject-Exits $gOu1)) {New-ADOrganizationalUnit -name $usr.client -path $gOu}
	$mGOu = $gOu1

	# add subgroup if subfolder ie OU=Venders,OU=a,OU=a, DC=a,DC=com
	if ($subFolder) {
		$gOu2 = "OU={0}, OU={1},OU=Groups,{2}" -f $usr.subFolder, $usr.client, $ad
		if (-not (ADObject-Exits $gOu2)) {
			New-ADOrganizationalUnit -path $gOu1 -name $usr.subFolder
			$mGOu =$gOu2
		}
	}
	$usr.groupOu = $mGOu

	### users ou paths ###

	# go to client folder OU=citi,OU=Clients,DC=havaschicago,DC=com
	$cOu = "OU=Clients,{0}" -f $ad
	$cOu1 = "OU={0},OU=Clients,{1}" -f $usr.client, $ad
	if (-not(ADObject-Exits $cOu1)) { New-ADOrganizationalUnit -name $usr.client -path $cOu	}

	if ($subFolder) {
		$cOu2 = "OU={0},OU={1},OU=Clients,{2}" -f $usr.subFolder, $usr.client, $ad
		if (-not(ADObject-Exits $cOu2)) {New-ADOrganizationalUnit -name $usr.subFolder -path $cOu1 }

		$cOu3 = "OU={0},OU={1}, OU={2},OU=Clients,{3}" -f $usr.Company, $usr.subFolder, $usr.client, $ad
		if (-not(ADObject-Exits $cOu3)) { New-ADOrganizationalUnit -path $cOu2 -name $usr.Company }
		$mClientOu = $cOu3
	}
	else {
		$cOu2 = "OU={0}, OU={1},OU=Clients,{2}" -f $usr.Company, $usr.client, $ad
		 if (-not(ADObject-Exits $cOu2)) {New-ADOrganizationalUnit -name $usr.Company -path $cOu1 }
		 $mClientOu = $cOu2
	}
	$usr.userou = $mClientOu
}


### user creation #################################################################################

Function GetOrSet-User {
	param( $usr)

	Try   { $exists = Get-ADUser -LDAPFilter ("(sAMAccountName={0})" -f $usr.sam ) }
	Catch { }
	If($exists) { return $exists }
	else {
	    $Psswd = ConvertTo-SecureString -AsPlainText $usr.Password -force

		New-ADUser -name $usr.name -SamAccountName $usr.sam -DisplayName $usr.DisplayName -GivenName $usr.GivenName -Surname $usr.SN -Description $usr.Description -EmailAddress  $usr.EMail -UserPrincipalName $usr.sam -Company $usr.Company -MobilePhone $usr.MobilePhone -OfficePhone $usr.Phone -AccountPassword $Psswd -Enabled $True -ChangePasswordAtLogon $False -path $usr.userou

		#$newdn = (Get-ADUser $sam).DistinguishedName
		#Rename-ADObject -Identity $newdn -NewName $DN
		return (Get-ADUser -LDAPFilter ("(sAMAccountName={0})" -f $usr.sam ))
	}
}

# Group Creation#################################################

Function GetOrSet-Group {
	param($usr)
	$grouplocation = "CN={0},{1}" -f $usr.Company, $usr.groupOu
	if ((ADObject-Exits $grouplocation)){ return ( get-adgroup $usr.Company )}
	else {
		New-ADGroup -Name $usr.Company -GroupScope 0 -path $usr.groupOu
		return (get-adgroup $usr.Company)
	}
}

Get-cvsData
