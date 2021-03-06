function job_release () {
	 param(	
			[string]$email,
			[string]$project_name,
			[string]$ae,
			[string]$ae_email,
			[string]$component,
			[string]$release_date,
			[string]$bp_number,
			[string]$job_number				 
		)
					 
	Import-Module activedirectory
	Import-Module c:\citiftp\utility_scripts\ad_password_reset_generator.ps1
	Import-Module c:\citiftp\utility_scripts\send_email.ps1


	$ftp_user = Get-ADUser -properties * -Filter {EmailAddress -like $email} -ErrorAction SilentlyContinue

	if($ftp_user) {

		$email_message = Get-Content c:\citiftp\utility_scripts\email_message.ps1 | Out-String

		
		$password = Reset-Password -email $email

		$email_body_message = $email_message -f $ftp_user.GivenName, $component, $project_name, $job_number, $release_date, $ae, $ae_email, $ftp_user.SamAccountName, $password
		
		Send-Email -email_address $email -email_body_text $email_body_message -ftp_user $ftp_user
		write-output $email_body_message
		
		Write-output ("Success! {0} was sent email\n" -f $email)
	} else { 
		Write-output ("\*** ERROR {0} email was not send to {0} Check to see if the email imputed is sames as AD\n*************" -f $email)
	}	
}

		
###### only edit here####
$email = "kclam@earthcolor.com"
$component = "Brochure"

$project_name = "Citi Double Cash Value Prop Reinforcement DM"
$bp_number = ""
$job_number = "62292"

$ae = "Erica Johnson"
$ae_email = "erica.johnson@havasww.com"
$release_date = "8/27"

##### DO NOT EDIT EDIT PAST HERE


job_release -email $email -project_name $project_name -ae $ae -ae_email $ae_email -component $component -release_date $release_date -bp_number $bp_number -job_number $job_number
