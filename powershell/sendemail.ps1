
#$emailSmtpServer = "mg01d1.eurorscg.com"
$emailSmtpServer = "10.160.10.23"
#$emailSmtpServerPort = "587"
$emailSmtpUser = "Chicago HelpDesk"
$emailSmtpPass = "Ek7hava5" 
$emailFrom = "chihelpdesk@havasww.com"
$emailTo = "paul.hawk@havasww.com" 
$emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )
$emailMessage.Subject = "Testing e-mail"
$emailMessage.IsBodyHtml = $False
$emailMessage.Body = "test"
#$SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
$SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer)
#$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass ); 

$SMTPClient.Send( $emailMessage )




































