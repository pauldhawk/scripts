$Users = Get-ADUser -Filter * -SearchBase "OU=a,OU=a,OU=a,DC=a,DC=com" -Properties GivenName, Surname, EmailAddress, UserPrincipalName, Company, MobilePhone, OfficePhone, PasswordExpired, PasswordLastSet
$Users | Export-Csv .\export.csv
