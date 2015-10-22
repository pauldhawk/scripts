import-module activedirectory

$Users = Get-ADUser -Filter { EmailAddress -like "*" -and Company -like "*"} `
	-SearchBase "OU=Venders,OU=citi,OU=Clients,DC=havaschicago,DC=com" `
	 -Properties GivenName, Surname, EmailAddress, UserPrincipalName, Company, MobilePhone, OfficePhone, PasswordExpired, PasswordLastSet

$users | Export-CSV -notype -Force C:/path/to/ad_vendors_output.csv
