### Email FTP users sctipt
### description: This Script is used to reset the passwords and email the users the new passwords
### author Paul Hawk Paul.hawk@havasww.com
### version: 1.1
### last update: 01.03.2014
###
	Import-Module activedirectory
	Import-Module ad_password_reset_generator.ps1
	Import-Module send_email.ps1


function get-csvData {
	#$eCsv = Import-CSV ".\email.csv"
	#$eCsv | ForEach-Object {
		#Send-Email -email ($_.email.trim())

		#write-output $_.email
		#Reset-Password -email $_.email
	#}

}

function reset-pass {
param($email)
#write-output ("trying to reset password " + $email)
$ftpuser = Get-ADUser -properties * -Filter {EmailAddress -like $email} -ErrorAction SilentlyContinue
$passwd =  Reset-Password -email $email
if ($ftpuser) {Set-ADAccountPassword $ftpuser -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $passwd -Force) }
}

function Send-Email {
	param($email
	)
	$passwd = Reset-Password -email $email
	reset-pass -email $email -passwd $passwd
	$ftpuser = Get-ADUser -properties * -Filter {EmailAddress -like $email} -ErrorAction SilentlyContinue

	if ($ftpuser) {

	write-output ("sending email to " + $email)


$message = @"
Hi {0},

Your ftp Credentials are:

U: {1}
P: {2}

instructions to get onto Havas FTP server:
1.
2.
3.
common issues:
1.
2.
3.

"@

 $sendMsg = $message -f $ftpuser.GivenName, $ftpuser.SamAccountName, $passwd
#write-output $sendMsg

	 $emailSmtpServer = ""
	 $emailSmtpUser = ""
	 $emailSmtpPass = ""
	 $emailFrom = ""
	 $emailTo = $email
	 $emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )

	 $emailMessage.Subject = "Havas FTP info"
	 $emailMessage.Body = $sendMsg

	 $SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer)
	 $SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass );
	 $SMTPClient.Send( $emailMessage )
	 Write-output ("sent email to {0}"-f $email)

	} else { Write-output ("\*** ERROR {0} email was not send to {0} Check to see if the email imputed is sames as AD\n*************" -f $email)}
}

#### ONLY EDIT BELOW
#### CAN DO MULTIPLE EMAILS JUST USE:
# Send-Email -email ""
#PUTTING THE EMAIL BETWEEN THE QUOTES
Send-Email -email ""
