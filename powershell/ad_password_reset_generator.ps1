function Reset-Password {
	param(	[Parameter(Mandatory=$True,Position=1)]
			[string]$email
	)
	$str = ($email * 8)
	$str = $str.substring(0,10)
	$rndNumbers = "37917042865"
	$rndLetters = "vxrflmhopuawngtqsdbeikzj"
	$rndSymbols = "!@#$%^&*"
	$wkNumber = get-date -UFormat %V

	$arr = @()
	$name = $str.tochararray()
	$nameNumber = @()
	$len = $name.length
	$pswd = ""
	for ($x=0; $x -lt $len; $x++ ) { $nameNumber += ([int] [char]($name[$x]) + $x + $wkNumber) }

	$pswd = "{0}{1}" -f $pswd, $rndLetters[($nameNumber[0] % $rndLetters.Length)]
	$pswd = $pswd.toupper()
	$pswd = "{0}{1}" -f $pswd, $rndSymbols[($nameNumber[1] % $rndSymbols.Length)]
	$pswd = "{0}{1}" -f $pswd, $rndLetters[($nameNumber[2] % $rndLetters.Length)]
	$pswd = "{0}{1}" -f $pswd, $rndSymbols[($nameNumber[3] % $rndSymbols.Length)]
	$pswd = "{0}{1}" -f $pswd, $rndLetters[($nameNumber[4] % $rndLetters.Length)]
	$pswd = "{0}{1}" -f $pswd, $rndNumbers[($nameNumber[5] % $rndNumbers.Length)]
	$pswd = "{0}{1}" -f $pswd, $rndSymbols[($nameNumber[6] % $rndSymbols.Length)]
	$pswd = "{0}{1}" -f $pswd, $rndNumbers[($nameNumber[7] % $rndNumbers.Length)]
	$pswd = "{0}{1}" -f $pswd, $rndLetters[($nameNumber[8] % $rndLetters.Length)]
	$pswd = "{0}{1}" -f $pswd, $rndLetters[($nameNumber[9] % $rndLetters.Length)]
    
	$ftpuser = Get-ADUser -Filter {EmailAddress -like $email}
	if ($ftpuser) {Set-ADAccountPassword $ftpuser -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $pswd -Force)
		return $pswd}
	else {write-output "not user"}	
}