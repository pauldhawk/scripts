### Email FTP users sctipt
### description: This Script is used to reset the passwords and email the users the new passwords
### author Paul Hawk Paul.hawk@havasww.com
### version: 1.1
### last update: 01.03.2014
###
#$email="paul.hawk@havasww.com"

function Send-Email {
	param([Parameter(Mandatory=$True,Position=1)]
			[string]$email_address,
	[Parameter(Mandatory=$True,Position=2)]
			[string]$email_body_text,
	[Parameter(Mandatory=$True,Position=3)]
			$ftp_user
	)

	$ftpuser = Get-ADUser -properties * -Filter {EmailAddress -like $email} -ErrorAction SilentlyContinue

	if ($ftp_user) {
		$emailSmtpServer = ""
		$emailSmtpUser = ""
		$emailSmtpPass = ""
		$emailFrom =  ""
		$emailTo = $email_address

		$emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )

		$emailMessage.Subject = "Havas FTP info"
		$emailMessage.Body = $email_body_text

		$SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer)
		$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass );
		$SMTPClient.Send( $emailMessage )

		Write-output ("Success! {0} was sent email {0}\n" -f $email_to)
		} else { Write-output ("*** ERROR {0} was NOT sent email." -f $email_to)}
}
