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

	$ftp_user = Get-ADUser -properties * -Filter {EmailAddress -like $email} -ErrorAction SilentlyContinue

	if ($ftp_user) { 
		$emailSmtpServer = "mg01d1.eurorscg.com"
		$emailSmtpUser = "Chicago HelpDesk"
		$emailSmtpPass = "Ek7hava5" 
		$emailFrom =  "chihelpdesk@havasww.com"
		$emailTo = $email_address
		
		$emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )
		 
		$emailMessage.Subject = "Havas FTP info"
		$emailMessage.Body = $email_body_text
		 
		$SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer)
		$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass ); 
		$SMTPClient.Send( $emailMessage )
		 
		
		} else {}	
}
